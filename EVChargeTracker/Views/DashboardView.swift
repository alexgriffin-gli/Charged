import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var viewModel = DashboardViewModel()
    @Binding var selectedVehicleIndex: Int
    @State private var showingAddChargingView = false

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if !vehicleManager.vehicles.isEmpty {
                    let vehicle = vehicleManager.vehicles[selectedVehicleIndex]

                    // Custom Header
                    ZStack(alignment: .bottomLeading) {
                        if let imageData = vehicle.bannerImageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .center)
                                .frame(height: 160) // Reduced height
                                .clipped()
                        } else {
                            Color.gray.frame(height: 160)
                        }

                        VStack(alignment: .leading) {
                            Text(vehicle.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(vehicle.year) \(vehicle.make) \(vehicle.model) \(vehicle.trim)")
                            Text(vehicle.vin)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.deepForestGreen)

                    // Section Divider
                    Text("CHARGING STATS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    // Metrics Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        MetricCard(title: "Avg. Efficiency", value: String(format: "%.2f mi/kWh", viewModel.averageEfficiency))
                        MetricCard(title: "Last Efficiency", value: String(format: "%.2f mi/kWh", viewModel.lastEfficiency))
                        MetricCard(title: "Best Efficiency", value: String(format: "%.2f mi/kWh", viewModel.bestEfficiency))
                        MetricCard(title: "Total Miles", value: String(format: "%.0f", viewModel.totalMilesTracked))
                        MetricCard(title: "Total Cost", value: String(format: "$%.2f", viewModel.totalCost))
                        MetricCard(title: "Total Energy", value: String(format: "%.1f kWh", viewModel.totalEnergy))
                    }
                    .padding()

                    // Section Divider
                    Text("CHARGE SUMMARY")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        MetricCard(title: "Fuel Logs", value: "\(viewModel.totalChargingSessions)")
                        MetricCard(title: "Total Fuel Cost", value: String(format: "$%.2f", viewModel.totalCost))
                        MetricCard(title: "Total kWh Charged", value: String(format: "%.1f", viewModel.totalEnergy))
                    }
                    .padding()

                    // Charts
                    VStack(spacing: 20) {
                        PieChartView(cityPercentage: viewModel.cityDrivingPercentage, highwayPercentage: viewModel.highwayDrivingPercentage)
                            .frame(height: 250)
                        EfficiencyGraphView(data: viewModel.efficiencyData)
                            .frame(height: 250)
                    }
                    .padding()
                } else {
                    Text("No vehicles added yet. Please add a vehicle to get started.")
                        .padding()
                }
            }
        }
        .background(Color.white)
        .navigationBarTitle("Dashboard")
        .navigationBarItems(trailing: Button("+Add Charge") {
            showingAddChargingView = true
        })
        .onAppear(perform: updateViewModel)
        .onChange(of: selectedVehicleIndex) { _ in updateViewModel() }
        .sheet(isPresented: $showingAddChargingView) {
            if !vehicleManager.vehicles.isEmpty {
                AddChargingView(vehicle: vehicleManager.vehicles[selectedVehicleIndex])
            }
        }
    }

    private func updateViewModel() {
        if !vehicleManager.vehicles.isEmpty {
            viewModel.update(with: vehicleManager.vehicles[selectedVehicleIndex])
        }
    }
}
