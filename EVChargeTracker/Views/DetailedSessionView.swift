import SwiftUI

struct DetailedSessionView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
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
                    deleteSession()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Session Details")
    }

    private func deleteSession() {
        if let vehicle = vehicleManager.currentVehicle,
           let sessionIndex = vehicle.chargingSessions.firstIndex(where: { $0.id == session.id }) {
            vehicleManager.deleteChargingSession(for: vehicle, at: IndexSet(integer: sessionIndex))
        }
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
            .environmentObject(VehicleManager())
    }
}
