import SwiftUI

struct MainView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var showingAddVehicleView = false
    @State private var selectedVehicleIndex = 0

    var body: some View {
        Group {
            if vehicleManager.vehicles.isEmpty {
                // Show a placeholder view with a button to add a vehicle
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
                // Main TabView
                TabView {
                    DashboardView(selectedVehicleIndex: $selectedVehicleIndex)
                        .tabItem {
                            Label("Dashboard", systemImage: "gauge")
                        }

                    ChargingHistoryView(vehicle: vehicleManager.vehicles[selectedVehicleIndex])
                        .tabItem {
                            Label("History", systemImage: "list.bullet")
                        }

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
                .accentColor(.deepForestGreen)
            }
        }
        .onAppear {
            if vehicleManager.vehicles.isEmpty {
                showingAddVehicleView = true
            }
        }
    }
}
