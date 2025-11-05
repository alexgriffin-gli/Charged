internal import SwiftUI

struct ContentView: View {
    @StateObject private var vehicleManager = VehicleManager()
    @State private var selectedVehicle: Vehicle?
    @State private var showingAddVehicle = false

    var body: some View {
        TabView {
            NavigationView {
                DashboardView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle, showingAddVehicle: $showingAddVehicle)
            }
            .tabItem {
                Image(systemName: "gauge.high")
                Text("Dashboard")
            }

            NavigationView {
                HistoryView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle)
                    .navigationTitle("Charging History")
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
        }
        .sheet(isPresented: $showingAddVehicle) {
            AddVehicleView()
                .environmentObject(vehicleManager)
        }
        .onAppear {
            if selectedVehicle == nil {
                selectedVehicle = vehicleManager.vehicles.first
            }
        }
    }
}
