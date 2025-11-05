internal import SwiftUI

struct DashboardView: View {
    @ObservedObject var vehicleManager: VehicleManager
    @Binding var selectedVehicle: Vehicle?
    @Binding var showingAddVehicle: Bool

    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddChargingSession = false
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            mainContent

            if isMenuOpen {
                hamburgerMenu
            }
        }
        .navigationTitle(selectedVehicle?.name ?? "Dashboard")
        .toolbar { navigationToolbar }
        .sheet(isPresented: $showingAddChargingSession) {
            AddChargingSessionView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle)
        }
        .onAppear(perform: updateViewModel)
        .onChange(of: selectedVehicle) { _ in updateViewModel() }
    }
}

// MARK: - Private Subviews
private extension DashboardView {

    @ViewBuilder
    var mainContent: some View {
        if let vehicle = selectedVehicle {
            ScrollView {
                VStack(spacing: 20) {
                    bannerImage(for: vehicle)
                    statsHeader
                    metricCards
                    drivingMixChart
                    efficiencyGraph
                }
            }
        } else {
            emptyState
        }
    }

    func bannerImage(for vehicle: Vehicle) -> some View {
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
                Text("\(vehicle.make) \(vehicle.model) (\(vehicle.year, specifier: "%d"))")
                    .font(.headline)
                Text("Trim: \(vehicle.trim) | VIN: \(vehicle.vin)")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.5))
        }
    }

    var statsHeader: some View {
        Text("CHARGING STATS")
            .font(.headline)
            .foregroundColor(.secondary)
            .padding(.top)
    }

    var metricCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            MetricCard(title: "Avg. Efficiency", value: String(format: "%.2f mi/kWh", viewModel.averageEfficiency))
            MetricCard(title: "Last Efficiency", value: String(format: "%.2f mi/kWh", viewModel.lastEfficiency))
            MetricCard(title: "Best Efficiency", value: String(format: "%.2f mi/kWh", viewModel.bestEfficiency))
            MetricCard(title: "Total Miles", value: String(format: "%.0f mi", viewModel.totalMilesTracked))
        }
        .padding(.horizontal)
    }

    var drivingMixChart: some View {
        PieChartView(cityPercentage: viewModel.cityDrivingPercentage, highwayPercentage: viewModel.highwayPercentage)
            .frame(height: 150)
            .padding()
    }

    var efficiencyGraph: some View {
        EfficiencyGraphView(data: viewModel.efficiencyData)
            .frame(height: 250)
            .padding()
    }

    var emptyState: some View {
        Text("Select or add a vehicle to get started.")
    }

    var hamburgerMenu: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isMenuOpen = false
                    }
                }

            HamburgerMenuView(
                vehicleManager: vehicleManager,
                selectedVehicle: $selectedVehicle,
                showingAddVehicle: $showingAddVehicle,
                isMenuOpen: $isMenuOpen
            )
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .transition(.move(edge: .leading))
            .zIndex(1)
        }
    }

    @ToolbarContentBuilder
    var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.3.horizontal")
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddChargingSession = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Charge")
                }
            }
            .disabled(selectedVehicle == nil)
        }
    }
}

// MARK: - Private Methods
private extension DashboardView {
    func updateViewModel() {
        if let vehicle = selectedVehicle {
            viewModel.update(with: vehicle)
        }
    }
}
