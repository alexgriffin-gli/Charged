internal import SwiftUI

struct HamburgerMenuView: View {
    @ObservedObject var vehicleManager: VehicleManager
    @Binding var selectedVehicle: Vehicle?
    @Binding var showingAddVehicle: Bool
    @Binding var isMenuOpen: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading) {
                    Text("My Vehicles")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, (geometry.size.height * 0.2)) // 20% from the top
                        .padding(.leading)

                    List {
                        ForEach(vehicleManager.vehicles) { vehicle in
                            Button(action: {
                                self.selectedVehicle = vehicle
                                withAnimation {
                                    self.isMenuOpen = false
                                }
                            }) {
                                Text(vehicle.name)
                                    .fontWeight(vehicle.id == selectedVehicle?.id ? .bold : .regular)
                                    .padding(vehicle.id == selectedVehicle?.id ? 10 : 0)
                                    .background(vehicle.id == selectedVehicle?.id ? Color.deepForestGreen : Color.clear)
                                    .foregroundColor(vehicle.id == selectedVehicle?.id ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())

                    NavigationLink(destination: HistoryView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle)) {
                        Text("History")
                    }
                    .padding(.leading)

                    Spacer()

                    Button(action: {
                        showingAddVehicle = true
                        isMenuOpen = false
                    }) {
                        Text("Add Vehicle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.deepForestGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, (geometry.size.height * 0.2)) // 20% from the bottom
                }
                .frame(width: geometry.size.width * 0.4) // 40% of the screen width
                .background(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)

                Spacer() // This will push the menu to the left
            }
        }
    }
}
