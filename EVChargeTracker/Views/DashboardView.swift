internal import SwiftUI

struct DashboardView: View {
    @ObservedObject var vehicleManager: VehicleManager
    let vehicle: Vehicle
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddChargingSession = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Banner Image
                ZStack(alignment: .bottomLeading) {
                    if let imageData = vehicle.bannerImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 200)
                    }

                    VStack(alignment: .leading) {
                        Text(vehicle.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("\(vehicle.make) \(vehicle.model) - \(vehicle.year, specifier: "%d")")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                }

                // Charging Stats Header
                Text("CHARGING STATS")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)

                // Metric Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    MetricCard(title: "Avg. Efficiency", value: String(format: "%.2f mi/kWh", viewModel.averageEfficiency))
                    MetricCard(title: "Last Efficiency", value: String(format: "%.2f mi/kWh", viewModel.lastEfficiency))
                    MetricCard(title: "Best Efficiency", value: String(format: "%.2f mi/kWh", viewModel.bestEfficiency))
                    MetricCard(title: "Total Miles", value: String(format: "%.0f mi", viewModel.totalMilesTracked))
                }
                .padding(.horizontal)

                // Driving Mix
                PieChartView(cityPercentage: viewModel.cityDrivingPercentage, highwayPercentage: viewModel.highwayDrivingPercentage)
                    .frame(height: 150)
                    .padding()

                // Efficiency Graph
                EfficiencyGraphView(data: viewModel.efficiencyData)
                    .frame(height: 250)
                    .padding()
            }
        }
        .onAppear {
            viewModel.update(with: vehicle)
        }
        .onChange(of: vehicle) { newVehicle in
            viewModel.update(with: newVehicle)
        }
        .navigationBarItems(trailing:
            Button(action: { showingAddChargingSession = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Charge")
                }
                .foregroundColor(.deepForestGreen)
            }
        )
        .sheet(isPresented: $showingAddChargingSession) {
            AddChargingSessionView(vehicleManager: vehicleManager, selectedVehicle: .constant(vehicle))
        }
    }
}
