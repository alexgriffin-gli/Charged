import SwiftUI

struct MainView: View {
    @EnvironmentObject var vehicleManager: VehicleManager

    var body: some View {
        if vehicleManager.currentVehicle != nil {
            TabView {
                DashboardView(vehicle: vehicleManager.currentVehicle!)
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.bar.xaxis")
                    }

                ChargingHistoryView(vehicle: vehicleManager.currentVehicle!)
                    .tabItem {
                        Label("History", systemImage: "list.bullet")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .accentColor(.forestGreen)
        } else {
            AddVehicleView()
                .accentColor(.forestGreen)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(VehicleManager())
    }
}
