import SwiftUI

struct DashboardView: View {
    let vehicle: Vehicle
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddChargingView = false
    @State private var showingSettingsView = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        headerView

                        // Section Divider
                        sectionDivider

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
            .onChange(of: vehicle.chargingSessions) { _ in
                viewModel.update(with: vehicle)
            }
            .sheet(isPresented: $showingAddChargingView) {
                AddChargingView(vehicle: vehicle)
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
    }

    private var headerView: some View {
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

    private var sectionDivider: some View {
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
        // Create a sample vehicle with some data for the preview
        let vehicle = Vehicle(id: UUID(), name: "My Tesla", make: "Tesla", model: "Model Y", year: 2023, trim: "Long Range", vin: "12345")
        // You would typically inject a VehicleManager here that has a sample vehicle
        DashboardView(vehicle: vehicle)
    }
}
