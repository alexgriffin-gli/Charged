import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @ObservedObject var vehicleManager = VehicleManager.shared
    @EnvironmentObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("My Vehicles")
                .font(.title)
                .bold()
                .padding(.leading)
                .padding(.top, 100)

            // Vehicle List
            ForEach(vehicleManager.vehicles) { vehicle in
                Button(action: {
                    dashboardViewModel.selectedVehicle = vehicle
                    isShowing = false
                }) {
                    Text(vehicle.name)
                        .font(.headline)
                }
                .padding(.leading)
            }

            // Add Vehicle Button
            NavigationLink(destination: AddVehicleView()) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Vehicle")
                }
                .font(.headline)
            }
            .padding(.leading)

            Spacer()

            // Settings
            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .font(.headline)
            }
            .padding(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .edgesIgnoringSafeArea(.all)
    }
}
