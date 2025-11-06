import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var vehicleManager = VehicleManager.shared
    @State private var selectedVehicle: Vehicle?
    @State private var showingShareSheet = false
    @State private var csvURL: URL?

    private let exportService = ExportService()

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: Binding<Bool>(
                    get: { self.themeManager.colorScheme == .dark },
                    set: { self.themeManager.colorScheme = $0 ? .dark : .light }
                ))
            }

            Section(header: Text("Data")) {
                Picker("Select Vehicle", selection: $selectedVehicle) {
                    ForEach(vehicleManager.vehicles) { vehicle in
                        Text(vehicle.name).tag(Optional(vehicle))
                    }
                }

                Button("Export Data") {
                    if let vehicle = selectedVehicle, let url = exportService.generateCSV(for: vehicle) {
                        self.csvURL = url
                        self.showingShareSheet = true
                    }
                }
                .disabled(selectedVehicle == nil)
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showingShareSheet) {
            if let csvURL = self.csvURL {
                ShareSheet(url: csvURL)
            }
        }
        .onAppear {
            if selectedVehicle == nil {
                selectedVehicle = vehicleManager.vehicles.first
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
