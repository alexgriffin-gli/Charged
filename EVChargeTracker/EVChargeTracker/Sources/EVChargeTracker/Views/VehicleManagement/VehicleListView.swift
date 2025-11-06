import SwiftUI

struct VehicleListView: View {
    @ObservedObject var vehicleManager = VehicleManager.shared
    @State private var showingAddVehicleView = false

    var body: some View {
        NavigationView {
            List {
                ForEach($vehicleManager.vehicles) { $vehicle in
                    NavigationLink(destination: VehicleDetailView(vehicle: $vehicle)) {
                        VStack(alignment: .leading) {
                            Text(vehicle.name)
                                .font(.headline)
                            Text("\(vehicle.make) \(vehicle.model)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: vehicleManager.deleteVehicle)
            }
            .navigationTitle("Vehicles")
            .navigationBarItems(trailing: Button(action: {
                showingAddVehicleView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddVehicleView) {
                AddVehicleView()
            }
        }
    }
}
