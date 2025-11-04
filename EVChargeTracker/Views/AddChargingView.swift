import SwiftUI

struct AddChargingView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) var presentationMode
    var vehicle: Vehicle

    @State private var date = Date()
    @State private var odometer: String = ""
    @State private var energyAdded: String = ""
    @State private var totalCost: String = ""
    @State private var isPartialCharge = false
    @State private var isMissedCharge = false
    @State private var cityDrivingPercentage: String = ""
    @State private var chargerType: String = ""
    @State private var location: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Odometer", text: $odometer)
                        .keyboardType(.decimalPad)
                    TextField("Energy Added (kWh)", text: $energyAdded)
                        .keyboardType(.decimalPad)
                    TextField("Total Cost", text: $totalCost)
                        .keyboardType(.decimalPad)
                    TextField("City Driving (%)", text: $cityDrivingPercentage)
                        .keyboardType(.numberPad)
                    TextField("Charger Type", text: $chargerType)
                    TextField("Location", text: $location)
                }

                Section {
                    Toggle("Partial Charge", isOn: $isPartialCharge)
                    Toggle("Missed Charge", isOn: $isMissedCharge)
                }

                Section {
                    Button("Save Session") {
                        saveSession()
                    }
                }
            }
            .navigationTitle("Add Charging Session")
        }
    }

    private func saveSession() {
        guard let odometerValue = Double(odometer),
              let energyAddedValue = Double(energyAdded),
              let totalCostValue = Double(totalCost),
              let cityDrivingPercentageValue = Int(cityDrivingPercentage) else {
            // Handle invalid input
            return
        }

        let newSession = ChargingSession(
            id: UUID(),
            date: date,
            odometer: odometerValue,
            energyAdded: energyAddedValue,
            totalCost: totalCostValue,
            isPartialCharge: isPartialCharge,
            isMissedCharge: isMissedCharge,
            cityDrivingPercentage: cityDrivingPercentageValue,
            chargerType: chargerType,
            location: location
        )

        vehicleManager.addChargingSession(to: vehicle, session: newSession)
        presentationMode.wrappedValue.dismiss()
    }
}
