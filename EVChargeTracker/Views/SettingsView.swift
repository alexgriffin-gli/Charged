import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var showingShareSheet = false
    @State private var csvURL: URL?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Data Export")) {
                    Button("Export to CSV") {
                        csvURL = vehicleManager.exportToCSV()
                        if csvURL != nil {
                            showingShareSheet = true
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingShareSheet) {
                if let url = csvURL {
                    ShareSheet(url: url)
                }
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
