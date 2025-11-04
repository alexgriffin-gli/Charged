import SwiftUI

struct ChargingHistoryView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    var vehicle: Vehicle?

    @State private var showingAddChargingView = false

    var body: some View {
        NavigationView {
            Group {
                if let vehicle = vehicle {
                    VStack {
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Recent Efficiency")
                                    .font(.headline)
                                Text("Best: \(String(format: "%.2f mi/kWh", bestEfficiency))")
                                Text("Last: \(String(format: "%.2f mi/kWh", lastEfficiency))")
                            }
                            .foregroundColor(.white)

                            Spacer()

                            EfficiencyBarGraphView(efficiencies: recentEfficiencies)
                                .frame(height: 100)
                        }
                        .padding()
                        .background(Color.deepForestGreen)

                        // List of sessions
                        List {
                            ForEach(vehicle.chargingSessions.sorted(by: { $0.date > $1.date })) { session in
                                HStack {
                                    // Charge Icon
                                    VStack {
                                        switch session.chargerType {
                                        case .level1:
                                            Image(systemName: "bolt.fill")
                                        case .level2:
                                            HStack(spacing: -5) {
                                                Image(systemName: "bolt.fill")
                                                Image(systemName: "bolt.fill")
                                            }
                                        case .level3:
                                            HStack(spacing: -5) {
                                                Image(systemName: "bolt.fill")
                                                Image(systemName: "bolt.fill")
                                                Image(systemName: "bolt.fill")
                                            }
                                        }
                                    }
                                    .frame(width: 40)

                                    // Log Info
                                    VStack(alignment: .leading) {
                                        Text(session.date, style: .date)
                                            .fontWeight(.bold)
                                        HStack {
                                            Text(String(format: "%.2f kWh", session.energyAdded))
                                            Text(String(format: "$%.2f", session.totalCost))
                                        }
                                    }

                                    Spacer()

                                    // Efficiency
                                    Text(String(format: "%.2f mi/kWh", sessionEfficiency(for: session)))
                                        .padding(8)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                            }
                            .onDelete(perform: deleteSession)
                        }
                    }
                } else {
                    Text("Select a vehicle to see its charging history.")
                }
            }
            .navigationTitle("Charging History")
            .navigationBarItems(trailing: Button("+Add Charge") {
                showingAddChargingView = true
            })
            .sheet(isPresented: $showingAddChargingView) {
                if let vehicle = vehicle {
                    AddChargingView(vehicle: vehicle)
                }
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        if let vehicle = vehicle {
            let sortedSessions = vehicle.chargingSessions.sorted(by: { $0.date > $1.date })
            let sessionsToDelete = offsets.map { sortedSessions[$0] }
            let indicesToDelete = sessionsToDelete.compactMap { session in
                vehicle.chargingSessions.firstIndex(where: { $0.id == session.id })
            }
            vehicleManager.deleteChargingSession(in: vehicle, at: IndexSet(indicesToDelete))
        }
    }

    private var recentEfficiencies: [Double] {
        guard let vehicle = vehicle else { return [] }
        return vehicle.chargingSessions.suffix(10).map { sessionEfficiency(for: $0) }
    }

    private var bestEfficiency: Double {
        guard let vehicle = vehicle else { return 0 }
        return vehicle.chargingSessions.map { sessionEfficiency(for: $0) }.max() ?? 0
    }

    private var lastEfficiency: Double {
        guard let vehicle = vehicle, let lastSession = vehicle.chargingSessions.last else { return 0 }
        return sessionEfficiency(for: lastSession)
    }

    private func sessionEfficiency(for session: ChargingSession) -> Double {
        guard let vehicle = vehicle, let index = vehicle.chargingSessions.firstIndex(where: { $0.id == session.id }), index > 0 else {
            return 0
        }
        let previousSession = vehicle.chargingSessions[index - 1]
        let distance = session.odometer - previousSession.odometer
        let energy = previousSession.energyAdded

        return distance > 0 && energy > 0 ? distance / energy : 0
    }
}
