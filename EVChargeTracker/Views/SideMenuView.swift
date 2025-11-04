import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Binding var selectedVehicleIndex: Int
    @Binding var isOpen: Bool
    @State private var showingAddVehicleView = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Vehicles")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            List {
                ForEach(0..<vehicleManager.vehicles.count, id: \.self) { index in
                    Button(action: {
                        selectedVehicleIndex = index
                        isOpen = false
                    }) {
                        Text(vehicleManager.vehicles[index].name)
                    }
                }
                .onDelete(perform: deleteVehicle)
            }

            Button(action: {
                showingAddVehicleView = true
            }) {
                Label("Add Vehicle", systemImage: "plus.circle.fill")
            }
            .padding()
            .sheet(isPresented: $showingAddVehicleView) {
                AddVehicleView()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }

    private func deleteVehicle(at offsets: IndexSet) {
        vehicleManager.deleteVehicle(at: offsets)
        if selectedVehicleIndex >= vehicleManager.vehicles.count {
            selectedVehicleIndex = vehicleManager.vehicles.count - 1
        }
    }
}
