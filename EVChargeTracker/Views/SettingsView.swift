import SwiftUI
import MessageUI

struct SettingsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Binding var selectedVehicleIndex: Int
    @State private var showingMailView = false
    @State private var csvURL: URL?
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Data Export")) {
                    Button("Export to CSV") {
                        let vehicle = vehicleManager.vehicles[selectedVehicleIndex]
                        csvURL = vehicleManager.exportToCSV(for: vehicle)
                        if csvURL != nil {
                            showingMailView = true
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingMailView) {
                if let url = csvURL {
                    MailView(url: url, result: $mailResult)
                }
            }
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    let url: URL
    @Binding var result: Result<MFMailComposeResult, Error>?

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("EV Charge Data")
        if let data = try? Data(contentsOf: url) {
            vc.addAttachmentData(data, mimeType: "text/csv", fileName: "charging_data.csv")
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            controller.dismiss(animated: true)
        }
    }
}
