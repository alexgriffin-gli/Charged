import SwiftUI

struct VehicleDetailView: View {
    @Binding var vehicle: Vehicle
    @State private var showingAddChargingSessionView = false

    var body: some View {
        VStack {
            Text(vehicle.name)
                .font(.largeTitle)
                .padding()

            Text("\(vehicle.year) \(vehicle.make) \(vehicle.model)")
                .font(.title2)
                .padding()

            List {
                ForEach(vehicle.chargingSessions) { session in
                    VStack(alignment: .leading) {
                        Text("Date: \(session.date, formatter: itemFormatter)")
                        Text("kWh Added: \(session.kwhAdded, specifier: "%.2f")")
                        Text("Total Cost: \((session.pricePerKWh * session.kwhAdded), specifier: "%.2f")")
                    }
                }
                .onDelete { indices in
                    vehicle.chargingSessions.remove(atOffsets: indices)
                }
            }

            Spacer()
        }
        .navigationTitle(vehicle.name)
        .navigationBarItems(trailing: Button(action: {
            showingAddChargingSessionView.toggle()
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddChargingSessionView) {
            AddChargingSessionView(vehicle: $vehicle)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter
}()
