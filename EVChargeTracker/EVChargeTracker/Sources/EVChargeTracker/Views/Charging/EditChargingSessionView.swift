import SwiftUI

struct EditChargingSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vehicleManager = VehicleManager.shared
    @Binding var session: ChargingSession
    let vehicleId: UUID

    @StateObject private var calculatorViewModel = CalculatorViewModel()

    @State private var date: Date
    @State private var odometer: String
    @State private var chargePercentage: Double
    @State private var isFullCharge: Bool
    @State private var isMissedCharge: Bool
    @State private var location: String
    @State private var paymentMethod: String
    @State private var chargingNetwork: String
    @State private var chargerType: Int

    let chargingNetworks = [
        "Electrify America", "EVgo", "ChargePoint", "Tesla", "Shell Recharge",
        "Blink", "SemaConnect", "Greenlots", "FLO", "Volta", "Other"
    ]

    init(session: Binding<ChargingSession>, vehicleId: UUID) {
        self._session = session
        self.vehicleId = vehicleId
        self._date = State(initialValue: session.wrappedValue.date)
        self._odometer = State(initialValue: String(session.wrappedValue.odometer))
        self._chargePercentage = State(initialValue: session.wrappedValue.chargePercentage)
        self._isFullCharge = State(initialValue: session.wrappedValue.isFullCharge)
        self._isMissedCharge = State(initialValue: session.wrappedValue.isMissedCharge)
        self._location = State(initialValue: session.wrappedValue.location)
        self._paymentMethod = State(initialValue: session.wrappedValue.paymentMethod)
        self._chargingNetwork = State(initialValue: session.wrappedValue.chargingNetwork)
        self._chargerType = State(initialValue: session.wrappedValue.chargerType)

        // Pre-populate the calculator ViewModel
        let viewModel = CalculatorViewModel()
        viewModel.totalCost = String(session.wrappedValue.pricePerKWh * session.wrappedValue.kwhAdded)
        viewModel.kwhAdded = String(session.wrappedValue.kwhAdded)
        viewModel.pricePerKWh = String(session.wrappedValue.pricePerKWh)
        self._calculatorViewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    CustomSectionHeader(title: "Session Details")
                    CustomDatePicker(title: "Date", date: $date)
                    CustomDivider()
                    CustomTextField(title: "Odometer", text: $odometer, keyboardType: .decimalPad)

                    CustomSectionHeader(title: "Cost Calculator")
                    CustomTextField(title: "Total Cost", text: $calculatorViewModel.totalCost, keyboardType: .decimalPad)
                    CustomDivider()
                    CustomTextField(title: "kWh Added", text: $calculatorViewModel.kwhAdded, keyboardType: .decimalPad)
                    CustomDivider()
                    CustomTextField(title: "Price per kWh", text: $calculatorViewModel.pricePerKWh, keyboardType: .decimalPad)

                    Button("Calculate") {
                        calculatorViewModel.calculate()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)

                    CustomSectionHeader(title: "Additional Info")
                    CustomPicker(title: "Charging Network", selection: $chargingNetwork, options: chargingNetworks)
                    CustomDivider()

                    Picker("Charger Type", selection: $chargerType) {
                        Text("Level 1").tag(1)
                        Text("Level 2").tag(2)
                        Text("Level 3 (DCFC)").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    LightningChargeView(chargePercentage: $chargePercentage)
                        .padding(.vertical, 10)

                    CustomDivider()

                    HStack {
                        CustomToggle(title: "Full Charge", isOn: $isFullCharge)
                        Spacer()
                        CustomToggle(title: "Missed Charge", isOn: $isMissedCharge)
                    }.padding(.horizontal)

                    CustomDivider()
                    CustomTextField(title: "Location", text: $location)
                    CustomDivider()
                    CustomTextField(title: "Payment Method", text: $paymentMethod)

                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Edit Charge")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let odometer = Double(odometer),
                   let pricePerKWh = Double(calculatorViewModel.pricePerKWh),
                   let kwhAdded = Double(calculatorViewModel.kwhAdded) {

                    let updatedSession = ChargingSession(
                        id: session.id,
                        date: date,
                        odometer: odometer,
                        pricePerKWh: pricePerKWh,
                        kwhAdded: kwhAdded,
                        chargePercentage: chargePercentage,
                        isFullCharge: isFullCharge,
                        location: location,
                        paymentMethod: paymentMethod,
                        chargingNetwork: chargingNetwork,
                        isMissedCharge: isMissedCharge,
                        chargerType: chargerType
                    )

                    vehicleManager.updateChargingSession(for: vehicleId, session: updatedSession)
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}
