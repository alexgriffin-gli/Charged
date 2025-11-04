import SwiftUI
import PhotosUI

struct AddVehicleView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var trim = ""
    @State private var vin = ""
    @State private var bannerImage: PhotosPickerItem? = nil
    @State private var bannerImageData: Data? = nil

    var isFormValid: Bool {
        !name.isEmpty && !make.isEmpty && !model.isEmpty && !year.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Details")) {
                    TextField("Name (e.g., My Tesla)", text: $name)
                    TextField("Make", text: $make)
                    TextField("Model", text: $model)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Trim", text: $trim)
                    TextField("VIN", text: $vin)
                }

                Section(header: Text("Banner Image")) {
                    PhotosPicker(selection: $bannerImage, matching: .images) {
                        if let data = bannerImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Label("Select a photo", systemImage: "photo")
                        }
                    }
                }
            }
            .navigationTitle("Add Vehicle")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveVehicle()
                }
                .disabled(!isFormValid)
            )
            .onChange(of: bannerImage) {
                Task {
                    if let data = try? await bannerImage?.loadTransferable(type: Data.self) {
                        bannerImageData = data
                    }
                }
            }
        }
    }

    private func saveVehicle() {
        guard let yearInt = Int(year) else { return }
        let newVehicle = Vehicle(
            id: UUID(),
            name: name,
            make: make,
            model: model,
            year: yearInt,
            trim: trim,
            vin: vin,
            bannerImageData: bannerImageData
        )
        vehicleManager.add(vehicle: newVehicle)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddVehicleView()
            .environmentObject(VehicleManager())
    }
}
