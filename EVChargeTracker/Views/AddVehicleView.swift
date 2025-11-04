import SwiftUI

import SwiftUI
import PhotosUI

struct AddVehicleView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var name: String = ""
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var trim: String = ""
    @State private var vin: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Information")) {
                    TextField("Name (e.g., My Tesla)", text: $name)
                    TextField("Make (e.g., Tesla)", text: $make)
                    TextField("Model (e.g., Model 3)", text: $model)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Trim", text: $trim)
                    TextField("VIN", text: $vin)
                }

                Section(header: Text("Banner Image")) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }

                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }

                Section {
                    Button("Save Vehicle") {
                        let yearInt = Int(year)
                        vehicleManager.addVehicle(name: name, make: make, model: model, year: yearInt, trim: trim, vin: vin, bannerImageData: selectedImageData)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Add Vehicle")
        }
    }
}
