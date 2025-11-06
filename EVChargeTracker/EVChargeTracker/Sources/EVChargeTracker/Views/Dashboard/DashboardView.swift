import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.deepForestGreen.opacity(0.3), .blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    BannerImageView()

                    if let vehicle = viewModel.selectedVehicle {
                        Picker("Select Vehicle", selection: $viewModel.selectedVehicle) {
                            ForEach(VehicleManager.shared.vehicles) { vehicle in
                                Text(vehicle.name).tag(Optional(vehicle))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        HStack(alignment: .top) {
                            // Left Column (Metrics)
                            VStack(spacing: 20) {
                                MetricCard(title: "AVG mi/KWH", value: String(format: "%.2f", viewModel.averageMilesPerKWh), symbolName: "speedometer")
                                MetricCard(title: "TOTAL COST", value: String(format: "$%.2f", viewModel.totalCost), symbolName: "dollarsign.circle")
                            }

                            // Right Column (Pie Chart & Miles)
                            VStack(spacing: 20) {
                                CardView {
                                    VStack {
                                        Text("Driving Mix")
                                        PieChartView()
                                    }
                                }
                                MetricCard(title: "TOTAL MILES", value: String(format: "%.0f", viewModel.totalMilesDriven), symbolName: "road.lanes")
                            }
                        }
                        .padding(.horizontal)

                    } else {
                        VStack {
                            Text("No vehicles found.")
                            NavigationLink("Add a vehicle to get started", destination: AddVehicleView())
                        }.padding()
                    }

                    NavigationLink(destination: VehicleListView()) {
                        Text("Manage Vehicles")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.deepForestGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                }
                .padding(.vertical)
            }
        }
    }
}
