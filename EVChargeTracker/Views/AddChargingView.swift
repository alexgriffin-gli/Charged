import SwiftUI

struct AddChargingView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) var presentationMode
    var vehicle: Vehicle

    // State variables for the form fields
    @State private var date = Date()
    @State private var odometer: String = ""
    @State private var energyAdded: String = ""
    @State private var totalCost: String = ""
    @State private var costPerKwh: String = ""
    @State private var isPartialCharge = false
    @State private var isMissedCharge = false
    @State private var cityDrivingPercentage: Double = 50.0
    @State private var chargerType: ChargerType = .level2
    @State private var location: LocationType = .home
    @State private var customLocation: String = ""
    @State private var paymentMethod: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Row 1: Vehicle Name
                Text(vehicle.name)
                    .font(.title)

                // Row 2: Odometer
                TextField("Odometer", text: $odometer)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Row 3: Charging Costs
                HStack {
                    TextField("Cost/kWh", text: $costPerKwh)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: costPerKwh) { _ in calculateMissingCostField() }
                    TextField("Energy Added (kWh)", text: $energyAdded)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: energyAdded) { _ in calculateMissingCostField() }
                    TextField("Total Cost", text: $totalCost)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: totalCost) { _ in calculateMissingCostField() }
                }

                // Row 4: Partial/Missed Charge
                HStack {
                    Toggle("Partial Charge", isOn: $isPartialCharge)
                        .toggleStyle(CheckboxToggleStyle())
                    Spacer()
                    Toggle("Missed Charge", isOn: $isMissedCharge)
                        .toggleStyle(CheckboxToggleStyle())
                }

                // Row 5: City Driving
                VStack {
                    Text("City Driving: \(Int(cityDrivingPercentage))%")
                    Slider(value: $cityDrivingPercentage, in: 0...100, step: 1)
                }

                // Row 6: Charger Type
                Picker("Charger Type", selection: $chargerType) {
                    ForEach(ChargerType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                // Row 7: Date
                DatePicker("Date", selection: $date)

                // Row 8: Location
                VStack {
                    Picker("Location", selection: $location) {
                        ForEach(LocationType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if location == .custom {
                        TextField("Custom Location", text: $customLocation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                // Row 9: Payment Method
                TextField("Payment Method", text: $paymentMethod)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Add Charge")
            .navigationBarItems(trailing: Button("Save") {
                saveSession()
            })
        }
    }

    private func calculateMissingCostField() {
        let energy = Double(energyAdded)
        let cost = Double(totalCost)
        let perKwh = Double(costPerKwh)

        if let energy = energy, let perKwh = perKwh, totalCost.isEmpty {
            totalCost = String(format: "%.2f", energy * perKwh)
        } else if let cost = cost, let perKwh = perKwh, energyAdded.isEmpty {
            guard perKwh > 0 else { return }
            energyAdded = String(format: "%.2f", cost / perKwh)
        } else if let cost = cost, let energy = energy, costPerKwh.isEmpty {
            guard energy > 0 else { return }
            costPerKwh = String(format: "%.2f", cost / energy)
        }
    }

    private func saveSession() {
        guard let odometerValue = Double(odometer),
              let energyAddedValue = Double(energyAdded),
              let totalCostValue = Double(totalCost),
              let costPerKwhValue = Double(costPerKwh) else {
            // Handle invalid input
            return
        }

        let newSession = ChargingSession(
            id: UUID(),
            date: date,
            odometer: odometerValue,
            energyAdded: energyAddedValue,
            totalCost: totalCostValue,
            costPerKwh: costPerKwhValue,
            isPartialCharge: isPartialCharge,
            isMissedCharge: isMissedCharge,
            cityDrivingPercentage: cityDrivingPercentage,
            chargerType: chargerType,
            location: location,
            customLocation: location == .custom ? customLocation : nil,
            paymentMethod: paymentMethod
        )

        vehicleManager.addChargingSession(to: vehicle, session: newSession)
        presentationMode.wrappedValue.dismiss()
    }
}
