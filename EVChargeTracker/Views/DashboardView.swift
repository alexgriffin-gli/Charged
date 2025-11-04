import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddChargingView = false
    @State private var showingSettingsView = false

    var body: some View {
        if let vehicle = vehicleManager.currentVehicle {
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            headerView(for: vehicle)

                            // Section Divider
                            sectionDivider(for: vehicle)

                            // Main Dashboard
                            mainDashboard
                                .padding()

                            // Fuel and Service Summary
                            summarySection
                                .padding(.horizontal)

                            // Fuel Efficiency Chart
                            efficiencyChart
                                .padding()
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                    .edgesIgnoringSafeArea(.top)

                    // Floating Action Button
                    floatingActionButton
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.update(with: vehicle)
                }
                .onChange(of: vehicleManager.currentVehicle?.chargingSessions) { _ in
                    if let updatedVehicle = vehicleManager.currentVehicle {
                        viewModel.update(with: updatedVehicle)
                    }
                }
                .sheet(isPresented: $showingAddChargingView) {
                    if let currentVehicle = vehicleManager.currentVehicle {
                        AddChargingView(vehicle: currentVehicle)
                            .environmentObject(vehicleManager)
                    }
                }
                .sheet(isPresented: $showingSettingsView) {
                    SettingsView()
                        .environmentObject(vehicleManager)
                }
            }
        } else {
            Text("No vehicle selected. Please add or select a vehicle in Settings.")
        }
    }

    private func headerView(for vehicle: Vehicle) -> some View {
        ZStack {
            if let bannerImage = vehicle.bannerImage {
                bannerImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            } else {
                Color.deepForestGreen
                    .frame(height: 150)
            }

            HStack {
                Button(action: {
                    showingSettingsView = true
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(vehicle.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
                // Placeholder for potential right-side icon
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.clear)
            }
            .padding(.top, 40)
            .padding(.horizontal)
        }
    }

    private func sectionDivider(for vehicle: Vehicle) -> some View {
        ZStack {
            Color.charcoalGray
                .frame(height: 80)
            Text(vehicle.name)
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundColor(.white)
        }
    }

    private var mainDashboard: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            VStack(spacing: 20) {
                MetricCardView(title: "AVG mi/KWH") { Text(String(format: "%.2f", viewModel.averageEfficiency)) }
                MetricCardView(title: "LAST mi/KWH") { Text(String(format: "%.2f", viewModel.lastEfficiency)) }
                MetricCardView(title: "BEST mi/KWH") {
                    Text(String(format: "%.2f", viewModel.bestEfficiency))
                        .foregroundColor(.teal)
                }
            }

            VStack(spacing: 20) {
                MetricCardView(title: "TOTAL MILES TRACKED") {
                    Text(String(format: "%.0f", viewModel.totalMilesTracked))
                        .fontWeight(.bold)
                }
                MetricCardView(title: "CITY / HIGHWAY %") {
                    PieChartView(cityPercentage: viewModel.cityDrivingPercentage, highwayPercentage: viewModel.highwayDrivingPercentage)
                }
            }
        }
    }

    private var summarySection: some View {
        HStack(spacing: 15) {
            SummaryCard(label: "FUEL LOGS", value: "\(viewModel.totalChargingSessions)")
            SummaryCard(label: "TOTAL FUEL COST", value: String(format: "$%.2f", viewModel.totalCost))
            SummaryCard(label: "TOTAL KWH CHARGED", value: String(format: "%.1f", viewModel.totalEnergy))
        }
    }

    private var efficiencyChart: some View {
        VStack {
            Text("Fuel Efficiency")
                .font(.title2)
                .foregroundColor(.teal)
            EfficiencyGraphView(efficiencyData: viewModel.efficiencyData)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }

    private var floatingActionButton: some View {
        Button(action: {
            showingAddChargingView = true
        }) {
            Image(systemName: "plus")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(Color.deepForestGreen)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding()
    }
}

// A helper view for the summary cards
struct SummaryCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.darkGray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.cardBackgroundColor)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let vehicleManager = VehicleManager()
        let sampleVehicle = Vehicle(id: UUID(), name: "My Tesla", make: "Tesla", model: "Model Y", year: 2023, trim: "Long Range", vin: "12345")
        vehicleManager.add(vehicle: sampleVehicle)
        vehicleManager.currentVehicle = sampleVehicle

        return DashboardView()
            .environmentObject(vehicleManager)
    }
}
