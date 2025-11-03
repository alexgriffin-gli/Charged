import SwiftUI

struct LogHistoryView: View {
    @EnvironmentObject var chargeManager: ChargeManager
    @State private var showingAddSheet = false
    @State private var document: CSVDocument?
    @State private var showingShareSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(chargeManager.sessions) { session in
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
                NewChargeView()
            }
            .sheet(item: $document) { doc in
                ShareSheet(activityItems: [doc.fileURL])
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        for index in offsets {
            let session = chargeManager.sessions[index]
            chargeManager.delete(session: session)
        }
    }

    private func exportData() {
        let csvString = DataExporter.exportToCSV(sessions: chargeManager.sessions)
        let doc = CSVDocument(text: csvString)
        self.document = doc
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

// Helper for sharing the CSV file
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }

    var text: String
    var fileURL: URL

    init(text: String) {
        self.text = text
        let tempDir = FileManager.default.temporaryDirectory
        self.fileURL = tempDir.appendingPathComponent("charging_sessions.csv")
        try? text.write(to: fileURL, atomically: true, encoding: .utf8)
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


struct LogHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        LogHistoryView()
            .environmentObject(ChargeManager())
    }
}
