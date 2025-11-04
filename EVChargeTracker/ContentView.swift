internal import SwiftUI

struct ContentView: View {
    @StateObject private var vehicleManager = VehicleManager()
    @State private var selectedVehicle: Vehicle?
    @State private var showingAddVehicle = false
    @State private var showingAddChargingSession = false
    @State private var isMenuOpen = false

    var body: some View {
        NavigationView {
            ZStack {
                // Main Content
                VStack {
                    if let vehicle = selectedVehicle {
                        DashboardView(vehicleManager: vehicleManager, vehicle: vehicle)
                    } else {
                        Text("Select or add a vehicle to get started.")
                    }
                }
                .navigationTitle(selectedVehicle?.name ?? "Dashboard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.deepForestGreen)
                        }
                    }
                }

                // Hamburger Menu
                if isMenuOpen {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }

                    HamburgerMenuView(
                        vehicleManager: vehicleManager,
                        selectedVehicle: $selectedVehicle,
                        showingAddVehicle: $showingAddVehicle,
                        isMenuOpen: $isMenuOpen
                    )
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
                }
            }
        }
        .sheet(isPresented: $showingAddVehicle) {
            AddVehicleView(vehicleManager: vehicleManager)
        }
        .onAppear {
            if selectedVehicle == nil {
                selectedVehicle = vehicleManager.vehicles.first
            }
        }
    }
}
