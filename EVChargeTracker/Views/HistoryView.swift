internal import SwiftUI
import MessageUI

struct HistoryView: View {
    @ObservedObject var vehicleManager: VehicleManager
    @Binding var selectedVehicle: Vehicle?
    @State private var showingAddChargingSession = false
    @State private var showingMailComposer = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            VStack {
                Text("Recent Efficiency")
                    .font(.headline)
                    .padding(.top)
                HStack {
                    VStack {
                        MetricCard(title: "Best Efficiency", value: String(format: "%.2f mi/kWh", viewModel.bestEfficiency))
                        MetricCard(title: "Last Efficiency", value: String(format: "%.2f mi/kWh", viewModel.lastEfficiency))
                    }
                    EfficiencyBarGraphView(efficiencies: viewModel.efficiencyData.map { $0.y })
                }
            }
            .frame(height: 200)
            .background(Color.white)


            // Session List
            if let vehicle = selectedVehicle {
                List {
                    ForEach(vehicle.chargingSessions.sorted { $0.date > $1.date }) { session in
                        HistoryRow(session: session)
                    }
                    .onDelete(perform: deleteSession)
                }
            } else {
                Text("Select a vehicle to see its charging history.")
                Spacer()
            }
        }
        .navigationTitle("Charging History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddChargingSession = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Charge")
                    }
                    .foregroundColor(.deepForestGreen)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showingMailComposer = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.deepForestGreen)
                }
            }
        }
        .sheet(isPresented: $showingAddChargingSession) {
            AddChargingSessionView(vehicleManager: vehicleManager, selectedVehicle: $selectedVehicle)
        }
        .sheet(isPresented: $showingMailComposer) {
            if let vehicle = selectedVehicle, let csvURL = vehicleManager.exportToCSV(for: vehicle) {
                MailComposeView(isShowing: $showingMailComposer, result: $mailResult, subject: "\(vehicle.name) Charging History", messageBody: "Attached is the charging history.", attachmentData: try? Data(contentsOf: csvURL), attachmentMimeType: "text/csv", attachmentFileName: "charging_history.csv")
            }
        }
        .onAppear {
            if let vehicle = selectedVehicle {
                viewModel.update(with: vehicle)
            }
        }
        .onChange(of: selectedVehicle) {
            if let vehicle = selectedVehicle {
                viewModel.update(with: vehicle)
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        if let vehicle = selectedVehicle {
            let sortedSessions = vehicle.chargingSessions.sorted { $0.date > $1.date }
            let originalOffsets = offsets.map { index in
                vehicle.chargingSessions.firstIndex(where: { $0.id == sortedSessions[index].id })!
            }
            vehicleManager.deleteChargingSession(in: vehicle, at: IndexSet(originalOffsets))
        }
    }
}
