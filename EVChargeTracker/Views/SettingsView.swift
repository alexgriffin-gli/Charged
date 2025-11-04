import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String { self.rawValue }
}

struct SettingsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @AppStorage("theme") private var selectedTheme: Theme = .system
    @State private var showingAddVehicleSheet = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                }

                Section(header: Text("Vehicles")) {
                    Picker("Current Vehicle", selection: $vehicleManager.currentVehicle) {
                        ForEach(vehicleManager.vehicles) { vehicle in
                            Text(vehicle.name).tag(vehicle as Vehicle?)
                        }
                    }

                    ForEach(vehicleManager.vehicles) { vehicle in
                        Text(vehicle.name)
                    }
                    .onDelete(perform: deleteVehicle)

                    Button("Add Vehicle") {
                        showingAddVehicleSheet = true
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAddVehicleSheet) {
                AddVehicleView()
            }
        }
    }

    private func deleteVehicle(at offsets: IndexSet) {
        for index in offsets {
            let vehicle = vehicleManager.vehicles[index]
            vehicleManager.delete(vehicle: vehicle)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(VehicleManager())
    }
}
