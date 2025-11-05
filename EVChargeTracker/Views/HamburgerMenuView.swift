import SwiftUI

struct HamburgerMenuView: View {
    @ObservedObject var vehicleManager: VehicleManager
    @Binding var selectedVehicle: Vehicle?
    @Binding var showingAddVehicle: Bool
    @Binding var isMenuOpen: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Vehicles")
                .font(.headline)
                .padding(.top, 100)
                .padding(.leading, 20)

            ForEach(vehicleManager.vehicles) { vehicle in
                Button(action: {
                    selectedVehicle = vehicle
                    withAnimation {
                        isMenuOpen = false
                    }
                }) {
                    Text(vehicle.name)
                        .foregroundColor(selectedVehicle == vehicle ? .white : .gray)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(selectedVehicle == vehicle ? Color.deepForestGreen.opacity(0.5) : Color.clear)
                        .cornerRadius(8)
                }
            }

            Button(action: {
                showingAddVehicle = true
                withAnimation {
                    isMenuOpen = false
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Vehicle")
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}
