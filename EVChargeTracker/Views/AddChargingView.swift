import SwiftUI

struct AddChargingView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) var presentationMode
    let vehicle: Vehicle

    @State private var date = Date()
    @State private var odometer = ""
    @State private var energyAdded = ""
    @State private var totalCost = ""
    @State private var isPartialCharge = false
    @State private var isMissedCharge = false
    @State private var cityDrivingPercentage = 50.0
    @State private var chargerType = "Level 2"
    @State private var location = ""
    @State private var paymentMethod = ""
    @State private var chargingNetwork = ""
    @State private var tags = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var lastOdometer: Double {
        vehicle.chargingSessions.first?.odometer ?? 0
    }

    var isFormValid: Bool {
        guard let odometerValue = Double(odometer),
              let energyAddedValue = Double(energyAdded),
              let _ = Double(totalCost) else {
            return false
        }

        guard odometerValue > lastOdometer else {
            return false
        }

        return energyAddedValue > 0
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle")) {
                    Text(vehicle.name)
                    Text("Last Odometer: \(String(format: "%.1f", lastOdometer))")
                }

                Section(header: Text("Charging Details")) {
                    DatePicker("Date", selection: $date)
                    TextField("Odometer", text: $odometer)
                        .keyboardType(.decimalPad)
                    TextField("Energy Added (kWh)", text: $energyAdded)
                        .keyboardType(.decimalPad)
                    TextField("Total Cost", text: $totalCost)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Toggle("Partial Charge?", isOn: $isPartialCharge)
                    Toggle("Missed Charge?", isOn: $isMissedCharge)
                }

                Section(header: Text("Driving Style")) {
                    VStack {
                        Text("City Driving: \(Int(cityDrivingPercentage))%")
                        Slider(value: $cityDrivingPercentage, in: 0...100, step: 1)
                    }
                }

                Section(header: Text("Charger Information")) {
                    TextField("Charger Type", text: $chargerType)
                    TextField("Charging Network", text: $chargingNetwork)
                    TextField("Location", text: $location)
                    TextField("Payment Method", text: $paymentMethod)
                }

                Section(header: Text("Tags")) {
                    TextField("Tags (comma separated)", text: $tags)
                }
            }
            .navigationTitle("New Charge")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    validateAndSave()
                }
                .disabled(!isFormValid)
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func validateAndSave() {
        guard let odometerValue = Double(odometer),
              let energyAddedValue = Double(energyAdded),
              let costValue = Double(totalCost) else {
            alertMessage = "Please ensure Odometer, Energy Added, and Total Cost are valid numbers."
            showAlert = true
            return
        }

        guard odometerValue > lastOdometer else {
            alertMessage = "The new odometer reading must be greater than the last one."
            showAlert = true
            return
        }

        guard energyAddedValue > 0 else {
            alertMessage = "Energy Added must be a positive number."
            showAlert = true
            return
        }

        let newSession = ChargingSession(
            id: UUID(),
            date: date,
            odometer: odometerValue,
            energyAdded: energyAddedValue,
            totalCost: costValue,
            isPartialCharge: isPartialCharge,
            isMissedCharge: isMissedCharge,
            cityDrivingPercentage: Int(cityDrivingPercentage),
            chargerType: chargerType,
            location: location,
            paymentMethod: paymentMethod,
            chargingNetwork: chargingNetwork,
            tags: tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        )
        vehicleManager.add(session: newSession, to: vehicle)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddChargingView_Previews: PreviewProvider {
    static var previews: some View {
        AddChargingView(vehicle: Vehicle(id: UUID(), name: "My EV", make: "Tesla", model: "Model 3", year: 2023))
            .environmentObject(VehicleManager())
    }
}
