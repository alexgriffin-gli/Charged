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
            // Main Content
            if let vehicle = selectedVehicle {
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
                        PieChartView(cityPercentage: viewModel.cityDrivingPercentage, highwayPercentage: viewModel.highwayPercentage)
                            .frame(height: 150)
                            .padding()

                        // Efficiency Graph
                        EfficiencyGraphView(data: viewModel.efficiencyData)
                            .frame(height: 250)
                            .padding()
                    }
                }
            } else {
                Text("Select or add a vehicle to get started.")
            }

            // Hamburger Menu
            if isMenuOpen {
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
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
        .navigationTitle(selectedVehicle?.name ?? "Dashboard")
        .toolbar {
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
        .sheet(isPresented: $showingAddChargingSession) {
            AddChargingSessionView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle)
        }
        .onAppear {
            if let vehicle = selectedVehicle {
                viewModel.update(with: vehicle)
            }
        }
        .onChange(of: selectedVehicle) {
            if let vehicle = selectedVehicle {
                viewModel.update(with: vehicle)
            }
        }
    }
}
