import SwiftUI

struct MainView: View {
    @EnvironmentObject var vehicleManager: VehicleManager

    var body: some View {
        if vehicleManager.currentVehicle != nil {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Vehicle Info", systemImage: "point.3.connected.trianglepath.dotted")
                    }

                ChargingHistoryView()
                    .tabItem {
                        Label("Vehicle Logs", systemImage: "list.dash")
                    }
            }
            .accentColor(.deepForestGreen)
        } else {
            AddVehicleView()
                .accentColor(.deepForestGreen)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        // Setup a sample vehicle for the preview
        let vehicleManager = VehicleManager()
        let sampleVehicle = Vehicle(id: UUID(), name: "Sample EV", make: "Tesla", model: "Model 3", year: 2023, trim: "Long Range", vin: "123")
        vehicleManager.add(vehicle: sampleVehicle)
        vehicleManager.currentVehicle = sampleVehicle

        return MainView()
            .environmentObject(vehicleManager)
    }
}
