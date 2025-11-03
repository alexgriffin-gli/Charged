import SwiftUI

struct DetailedSessionView: View {
    @EnvironmentObject var chargeManager: ChargeManager
    @Environment(\.presentationMode) var presentationMode
    let session: ChargingSession

    var body: some View {
        Form {
            Section(header: Text("Session Details")) {
                Text("Date: \(session.date, formatter: itemFormatter)")
                Text("Odometer: \(String(format: "%.1f", session.odometer)) mi")
                Text("Energy Added: \(String(format: "%.2f", session.energyAdded)) kWh")
                Text("Total Cost: $\(String(format: "%.2f", session.totalCost))")
            }

            Section(header: Text("Flags")) {
                Text("Partial Charge: \(session.isPartialCharge ? "Yes" : "No")")
                Text("Missed Charge: \(session.isMissedCharge ? "Yes" : "No")")
            }

            Section(header: Text("Driving and Charger")) {
                Text("City Driving: \(session.cityDrivingPercentage)%")
                Text("Charger Type: \(session.chargerType)")
                Text("Charging Network: \(session.chargingNetwork)")
                Text("Location: \(session.location)")
                Text("Payment Method: \(session.paymentMethod)")
            }

            Section {
                Button("Delete", role: .destructive) {
                    chargeManager.delete(session: session)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Session Details")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct DetailedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedSessionView(session: ChargingSession(id: UUID(), date: Date(), odometer: 70000, energyAdded: 45.0, totalCost: 15.75, isPartialCharge: false, isMissedCharge: false, cityDrivingPercentage: 50, chargerType: "DC Fast", location: "ChargePoint Station", paymentMethod: "Credit Card", chargingNetwork: "ChargePoint", tags: ["Road Trip"]))
            .environmentObject(ChargeManager())
    }
}
