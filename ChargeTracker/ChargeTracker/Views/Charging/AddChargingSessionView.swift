import SwiftUI

struct AddChargingSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vehicleManager = VehicleManager.shared
    @Binding var vehicle: Vehicle

    @StateObject private var calculatorViewModel = CalculatorViewModel()

    @State private var date = Date()
    @State private var odometer = ""
    @State private var chargePercentage: Double = 80
    @State private var isFullCharge = false
    @State private var isMissedCharge = false
    @State private var location = ""
    @State private var paymentMethod = ""
    @State private var chargingNetwork = "Other"
    @State private var chargerType = 2

    let chargingNetworks = [
        "Electrify America", "EVgo", "ChargePoint", "Tesla", "Shell Recharge",
        "Blink", "SemaConnect", "Greenlots", "FLO", "Volta", "Other"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    FormRow(label: "Date") { DatePicker("", selection: $date, displayedComponents: .date) }
                    FormDivider()
                    FormRow(label: "Odometer") { TextField("0.0", text: $odometer).keyboardType(.decimalPad) }
                    FormDivider()
                    FormRow(label: "Total Cost") { TextField("0.00", text: $calculatorViewModel.totalCost).keyboardType(.decimalPad) }
                    FormDivider()
                    FormRow(label: "kWh Added") { TextField("0.0", text: $calculatorViewModel.kwhAdded).keyboardType(.decimalPad) }
                    FormDivider()
                    FormRow(label: "Price per kWh") { TextField("0.00", text: $calculatorViewModel.pricePerKWh).keyboardType(.decimalPad) }
                    FormDivider()
                    FormRow(label: "Charging Network") {
                        Picker("", selection: $chargingNetwork) {
                            ForEach(chargingNetworks, id: \.self) { Text($0) }
                        }.pickerStyle(MenuPickerStyle())
                    }
                    FormDivider()
                    FormRow(label: "Charger Type") {
                        Picker("", selection: $chargerType) {
                            Text("L1").tag(1)
                            Text("L2").tag(2)
                            Text("DCFC").tag(3)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    FormDivider()

                    LightningChargeView(chargePercentage: $chargePercentage)
                        .padding()

                    FormDivider()

                    HStack {
                        Toggle("Full Charge", isOn: $isFullCharge)
                        Toggle("Missed Charge", isOn: $isMissedCharge)
                    }.padding()

                    FormDivider()
                    FormRow(label: "Location") { TextField("e.g. Home", text: $location) }
                    FormDivider()
                    FormRow(label: "Payment") { TextField("e.g. Visa", text: $paymentMethod) }

                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Charge")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                                trailing: Button("Save") { saveSession() })
        }
    }

    private func saveSession() {
        if let odometer = Double(odometer),
           let pricePerKWh = Double(calculatorViewModel.pricePerKWh),
           let kwhAdded = Double(calculatorViewModel.kwhAdded) {

            let newSession = ChargingSession(
                id: UUID(), date: date, odometer: odometer, pricePerKWh: pricePerKWh,
                kwhAdded: kwhAdded, chargePercentage: chargePercentage, isFullCharge: isFullCharge,
                location: location, paymentMethod: paymentMethod, chargingNetwork: chargingNetwork,
                isMissedCharge: isMissedCharge, chargerType: chargerType
            )
            vehicleManager.addChargingSession(to: vehicle.id, session: newSession)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Custom row and divider components for the form
struct FormRow<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            content
        }
        .padding()
    }
}

struct FormDivider: View {
    var body: some View {
        Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
    }
}
