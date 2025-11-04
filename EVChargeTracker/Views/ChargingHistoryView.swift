import SwiftUI

struct ChargingHistoryView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    var vehicle: Vehicle?

    var body: some View {
        NavigationView {
            if let vehicle = vehicle {
                List {
                    ForEach(vehicle.chargingSessions) { session in
                        NavigationLink(destination: DetailedSessionView(session: session)) {
                            VStack(alignment: .leading) {
                                Text("Date: \(session.date.formatted(date: .numeric, time: .omitted))")
                                Text("Odometer: \(String(format: "%.0f", session.odometer))")
                                Text("Energy Added: \(String(format: "%.2f kWh", session.energyAdded))")
                                Text("Total Cost: \(String(format: "$%.2f", session.totalCost))")
                            }
                        }
                    }
                    .onDelete(perform: deleteSession)
                }
                .navigationTitle("Charging History")
            } else {
                Text("Select a vehicle from the Dashboard to see its charging history.")
                    .navigationTitle("Charging History")
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        if let vehicle = vehicle {
            vehicleManager.deleteChargingSession(in: vehicle, at: offsets)
        }
    }
}
