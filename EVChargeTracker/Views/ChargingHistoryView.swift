import SwiftUI
import UniformTypeIdentifiers

struct ChargingHistoryView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    let vehicle: Vehicle
    @State private var showingAddSheet = false
    @State private var document: CSVDocument?
    @State private var showErrorAlert = false

    var body: some View {
        NavigationView {
            List {
                ForEach(vehicle.chargingSessions) { session in
                    NavigationLink(destination: DetailedSessionView(session: session)) {
                        VStack(alignment: .leading) {
                            Text("Date: \(session.date, formatter: itemFormatter)")
                                .font(.headline)
                            HStack {
                                Text("Energy: \(String(format: "%.2f", session.energyAdded)) kWh")
                                Spacer()
                                Text("Cost: $\(String(format: "%.2f", session.totalCost))")
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .navigationTitle("Log History")
            .navigationBarItems(
                leading: Button(action: {
                    exportData()
                }) {
                    Image(systemName: "square.and.arrow.up")
                },
                trailing: Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                AddChargingView(vehicle: vehicle)
            }
            .sheet(item: $document) { doc in
                ShareSheet(activityItems: [doc.fileURL])
            }
            .alert("Export Failed", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        if let index = vehicleManager.vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicleManager.vehicles[index].chargingSessions.remove(atOffsets: offsets)
        }
    }

    private func exportData() {
        if let csvURL = vehicle.generateCSV() {
            let doc = CSVDocument(fileURL: csvURL)
            self.document = doc
        } else {
            showErrorAlert = true
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct CSVDocument: FileDocument, Identifiable {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }

    let id = UUID()
    var text: String
    var fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
        self.text = (try? String(contentsOf: fileURL)) ?? ""
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
        fileURL = configuration.file.filename.flatMap { URL(string: $0) } ?? URL(fileURLWithPath: "")
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {}
}

struct ChargingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingHistoryView(vehicle: Vehicle(id: UUID(), name: "My EV", make: "Tesla", model: "Model 3", year: 2023, trim: "Long Range", vin: ""))
            .environmentObject(VehicleManager())
    }
}
