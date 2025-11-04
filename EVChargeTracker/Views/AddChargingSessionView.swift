internal import SwiftUI
import Combine

struct AddChargingSessionView: View {
    @ObservedObject var vehicleManager: VehicleManager
    @Binding var selectedVehicle: Vehicle?
    @Environment(\.presentationMode) var presentationMode

    // Focus state for text fields
    private enum Field: Hashable {
        case odometer, energyAdded, totalCost, costPerKwh, customLocation, paymentMethod
    }
    @FocusState private var focusedField: Field?

    // State for all ChargingSession properties
    @State private var date = Date()
    @State private var odometer: String = ""
    @State private var energyAdded: String = ""
    @State private var totalCost: String = ""
    @State private var costPerKwh: String = ""
    @State private var isPartialCharge: Bool = false
    @State private var isMissedCharge: Bool = false
    @State private var cityDrivingPercentage: Double = 50.0
    @State private var chargerType: ChargerType = .level2
    @State private var locationType: LocationType = .home
    @State private var customLocation: String = ""
    @State private var paymentMethod: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Vehicle", selection: $selectedVehicle) {
                        ForEach(vehicleManager.vehicles) { vehicle in
                            Text(vehicle.name).tag(vehicle as Vehicle?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TitledTextField(title: "Odometer", text: $odometer, keyboardType: .decimalPad, focused: $focusedField, field: .odometer)
                        .onReceive(Just(odometer)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.odometer = filtered
                            }
                            let parts = self.odometer.split(separator: ".")
                            if parts.count == 2 && parts[1].count > 2 {
                                self.odometer = "\(parts[0]).\(parts[1].prefix(2))"
                            }
                        }
                    TitledTextField(title: "Energy Added (kWh)", text: $energyAdded, keyboardType: .decimalPad, focused: $focusedField, field: .energyAdded)
                        .onReceive(Just(energyAdded)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.energyAdded = filtered
                            }
                            let parts = self.energyAdded.split(separator: ".")
                            if parts.count == 2 && parts[1].count > 4 {
                                self.energyAdded = "\(parts[0]).\(parts[1].prefix(4))"
                            }
                        }
                    TitledTextField(title: "Total Cost", text: $totalCost, keyboardType: .decimalPad, focused: $focusedField, field: .totalCost)
                        .onReceive(Just(totalCost)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.totalCost = filtered
                            }
                            let parts = self.totalCost.split(separator: ".")
                            if parts.count == 2 && parts[1].count > 2 {
                                self.totalCost = "\(parts[0]).\(parts[1].prefix(2))"
                            }
                        }
                    TitledTextField(title: "Cost/kWh", text: $costPerKwh, keyboardType: .decimalPad, focused: $focusedField, field: .costPerKwh)
                        .onReceive(Just(costPerKwh)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.costPerKwh = filtered
                            }
                            let parts = self.costPerKwh.split(separator: ".")
                            if parts.count == 2 && parts[1].count > 2 {
                                self.costPerKwh = "\(parts[0]).\(parts[1].prefix(2))"
                            }
                        }

                    Toggle("Partial Charge", isOn: $isPartialCharge)
                        .toggleStyle(CheckboxToggleStyle())
                    Toggle("Missed Charge", isOn: $isMissedCharge)
                        .toggleStyle(CheckboxToggleStyle())

                    BubblePicker(title: "Charger Type", selection: $chargerType, options: ChargerType.allCases)
                    BubblePicker(title: "Location", selection: $locationType, options: LocationType.allCases)

                    if locationType == .custom {
                        TitledTextField(title: "Custom Location", text: $customLocation, focused: $focusedField, field: .customLocation)
                    }

                    VStack(alignment: .leading) {
                        Text("City Driving: \(Int(cityDrivingPercentage))%")
                        Slider(value: $cityDrivingPercentage, in: 0...100, step: 1)
                            .accentColor(.deepForestGreen)
                    }

                    TitledTextField(title: "Payment Method", text: $paymentMethod, focused: $focusedField, field: .paymentMethod)
                }
                .padding()
            }
            .navigationTitle("Add Charge")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSession()
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
            .onChange(of: focusedField) { newFocus in
                if newFocus == nil {
                    calculate()
                }
            }
        }
    }

    private func calculate() {
        let costValue = Double(totalCost)
        let energyValue = Double(energyAdded)
        let costPerKwhValue = Double(costPerKwh)

        if let cost = costValue, let energy = energyValue, costPerKwh.isEmpty {
            costPerKwh = String(format: "%.2f", cost / energy)
        } else if let cost = costValue, let perKwh = costPerKwhValue, energyAdded.isEmpty {
            energyAdded = String(format: "%.4f", cost / perKwh)
        } else if let energy = energyValue, let perKwh = costPerKwhValue, totalCost.isEmpty {
            totalCost = String(format: "%.2f", energy * perKwh)
        }
    }

    private func saveSession() {
        guard let vehicle = selectedVehicle,
              let odometerValue = Double(odometer),
              let energy = Double(energyAdded),
              let cost = Double(totalCost),
              let costPerKwhValue = Double(costPerKwh) else {
            return
        }

        let newSession = ChargingSession(
            id: UUID(),
            date: date,
            odometer: odometerValue,
            energyAdded: energy,
            totalCost: cost,
            costPerKwh: costPerKwhValue,
            isPartialCharge: isPartialCharge,
            isMissedCharge: isMissedCharge,
            cityDrivingPercentage: cityDrivingPercentage,
            chargerType: chargerType,
            location: locationType,
            customLocation: locationType == .custom ? customLocation : nil,
            paymentMethod: paymentMethod.isEmpty ? nil : paymentMethod
        )

        vehicleManager.addChargingSession(to: vehicle, session: newSession)
        presentationMode.wrappedValue.dismiss()
    }
}
