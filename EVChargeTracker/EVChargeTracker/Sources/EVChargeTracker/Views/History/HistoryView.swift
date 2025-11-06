import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    @ObservedObject var vehicleManager = VehicleManager.shared
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.deepForestGreen.opacity(0.3), .blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Bar Chart for selected vehicle
                    if let vehicle = dashboardViewModel.selectedVehicle {
                        Text("\(vehicle.name) Efficiency (Last 10 Sessions)")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        if !viewModel.chartData.isEmpty {
                            BarChartView(data: viewModel.chartData)
                                .padding(.horizontal)
                        }

                        // Recent Efficiency Cards
                        HStack {
                            MetricCard(title: "Best mi/kWh", value: String(format: "%.2f", viewModel.bestMiKWh), symbolName: "star.fill")
                            MetricCard(title: "Last mi/kWh", value: String(format: "%.2f", viewModel.lastMiKWh), symbolName: "arrow.right.circle.fill")
                        }
                        .padding(.horizontal)
                    }

                    // History List for all vehicles
                    ForEach($vehicleManager.vehicles) { $vehicle in
                        VStack(alignment: .leading) {
                            Text(vehicle.name)
                                .font(.title2)
                                .bold()
                                .padding([.horizontal, .top])

                            ForEach($vehicle.chargingSessions) { $session in
                                NavigationLink(destination: EditChargingSessionView(session: $session, vehicleId: vehicle.id)) {
                                    HistoryRowView(session: session)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .onReceive(dashboardViewModel.$selectedVehicle) { vehicle in
            viewModel.updateChartData(with: vehicle)
        }
    }
}
