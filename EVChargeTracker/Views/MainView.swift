import SwiftUI

struct MainView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var showingAddVehicleView = false
    @State private var selectedVehicleIndex = 0
    @State private var isSideMenuOpen = false
    @State private var selectedTab: Tab = .dashboard

    enum Tab {
        case dashboard, history, settings
    }

    var body: some View {
        Group {
            if vehicleManager.vehicles.isEmpty {
                VStack {
                    Text("Welcome to EV Charge Tracker")
                        .font(.title)
                    Button("Add Your First Vehicle") {
                        showingAddVehicleView = true
                    }
                    .padding()
                    .background(Color.deepForestGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showingAddVehicleView) {
                    AddVehicleView()
                        .environmentObject(vehicleManager)
                }
            } else {
                NavigationView {
                    ZStack {
                        VStack {
                            // Main Content
                            switch selectedTab {
                        case .dashboard:
                            DashboardView(selectedVehicleIndex: $selectedVehicleIndex)
                        case .history:
                            ChargingHistoryView(vehicle: vehicleManager.vehicles[selectedVehicleIndex])
                        case .settings:
                            SettingsView(selectedVehicleIndex: $selectedVehicleIndex)
                        }

                        // Custom Tab Bar
                        HStack {
                            TabBarButton(title: "Dashboard", systemImage: "gauge", isSelected: selectedTab == .dashboard) {
                                selectedTab = .dashboard
                            }
                            TabBarButton(title: "History", systemImage: "list.bullet", isSelected: selectedTab == .history) {
                                selectedTab = .history
                            }
                            TabBarButton(title: "Settings", systemImage: "gear", isSelected: selectedTab == .settings) {
                                selectedTab = .settings
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                    }
                    .background(Color.white) // Set the background color to white

                    if isSideMenuOpen {
                        SideMenuView(selectedVehicleIndex: $selectedVehicleIndex, isOpen: $isSideMenuOpen)
                            .frame(width: 250)
                            .transition(.move(edge: .leading))
                    }
                }
                .navigationBarItems(leading: Button(action: {
                    withAnimation {
                        isSideMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                })
                }
            }
        }
        .onAppear {
            if vehicleManager.vehicles.isEmpty {
                showingAddVehicleView = true
            }
        }
    }
}

struct TabBarButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .deepForestGreen : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
