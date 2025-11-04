import SwiftUI

struct DashboardView: View {
    let vehicle: Vehicle
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if let bannerImage = vehicle.bannerImage {
                    bannerImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.top)
                        .opacity(0.3)
                }

                ScrollView {
                    VStack {
                        VStack {
                            Text("Dashboard")
                                .font(.largeTitle)
                            Text(vehicle.name)
                                .font(.title2)
                        }
                        .padding()

                        let sessions = vehicle.chargingSessions
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

                        VStack {
                            Text("Average Efficiency")
                                .font(.headline)
                            Text(String(format: "%.2f mi/kWh", vehicle.averageEfficiency))
                                .font(.title)
                        }
                        .padding()

                        EfficiencyGraphView(efficiencyData: viewModel.efficiencyData)

                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.prepareGraphData(sessions: vehicle.chargingSessions)
            }
            .onChange(of: vehicle.chargingSessions) {
                viewModel.prepareGraphData(sessions: vehicle.chargingSessions)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(vehicle: Vehicle(id: UUID(), name: "My EV", make: "Tesla", model: "Model 3", year: 2023, trim: "Long Range", vin: ""))
    }
}
