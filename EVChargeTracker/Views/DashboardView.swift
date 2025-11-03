import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var chargeManager: ChargeManager
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("EV Charge Tracker")
                    .font(.largeTitle)
                    .padding()

                let sessions = chargeManager.sessions
                let totalMiles = (sessions.first?.odometer ?? 0) - (sessions.last?.odometer ?? 0)
                let totalCost = sessions.map { $0.totalCost }.reduce(0, +)
                let totalEnergy = sessions.map { $0.energyAdded }.reduce(0, +)

                HStack {
                    VStack {
                        Text("Total Miles")
                            .font(.headline)
                        Text(String(format: "%.1f", totalMiles))
                            .font(.title)
                    }
                    .padding()

                    VStack {
                        Text("Total Cost")
                            .font(.headline)
                        Text(String(format: "$%.2f", totalCost))
                            .font(.title)
                    }
                    .padding()
                }

                HStack {
                    VStack {
                        Text("Total Energy")
                            .font(.headline)
                        Text(String(format: "%.1f kWh", totalEnergy))
                            .font(.title)
                    }
                    .padding()

                    VStack {
                        Text("Sessions")
                            .font(.headline)
                        Text("\(sessions.count)")
                            .font(.title)
                    }
                    .padding()
                }

                if let stats = EfficiencyCalculator.calculate(sessions: sessions) {
                    VStack {
                        Text("Efficiency")
                            .font(.headline)
                        HStack {
                            VStack {
                                Text("Average")
                                Text(String(format: "%.2f mi/kWh", stats.average))
                            }
                            .padding()
                            VStack {
                                Text("Last")
                                Text(String(format: "%.2f mi/kWh", stats.last))
                            }
                            .padding()
                            VStack {
                                Text("Best")
                                Text(String(format: "%.2f mi/kWh", stats.best))
                            }
                            .padding()
                        }
                    }
                    .padding()
                }

                EfficiencyGraphView(efficiencyData: viewModel.efficiencyData)

                Spacer()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.prepareGraphData(sessions: chargeManager.sessions)
            }
            .onChange(of: chargeManager.sessions) {
                viewModel.prepareGraphData(sessions: chargeManager.sessions)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(ChargeManager())
    }
}
