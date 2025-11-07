import SwiftUI

struct AddVehicleView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vehicleManager = VehicleManager.shared

    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                TextField("Year", text: $year)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Vehicle")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let yearInt = Int(year) {
                    let newVehicle = Vehicle(id: UUID(), name: name, make: make, model: model, year: yearInt, chargingSessions: [])
                    vehicleManager.addVehicle(newVehicle)
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}
