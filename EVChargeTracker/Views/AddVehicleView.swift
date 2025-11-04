internal import SwiftUI
import PhotosUI

struct AddVehicleView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var trim: String = ""
    @State private var vin: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var vehicleImageData: Data?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Details")) {
                    TextField("Name (e.g., My Tesla)", text: $name)
                    TextField("Make (e.g., Tesla)", text: $make)
                    TextField("Model (e.g., Model 3)", text: $model)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Trim", text: $trim)
                    TextField("VIN", text: $vin)
                }

                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        HStack {
                            if let imageData = vehicleImageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            } else {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Text("Select a photo")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Vehicle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveVehicle()
                    }
                }
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        vehicleImageData = data
                    }
                }
            }
        }
    }

    private func saveVehicle() {
        vehicleManager.addVehicle(
            name: name,
            make: make,
            model: model,
            year: Int(year) ?? 2023,
            trim: trim,
            vin: vin,
            bannerImageData: vehicleImageData
        )
        presentationMode.wrappedValue.dismiss()
    }
}
