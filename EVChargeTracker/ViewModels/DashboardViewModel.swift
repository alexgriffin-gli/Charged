import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var efficiencyData: [(x: String, y: Double)] = []

    func prepareGraphData(sessions: [ChargingSession]) {
        var data: [(x: String, y: Double)] = []
        let sortedSessions = sessions.sorted { $0.odometer < $1.odometer }

        guard sortedSessions.count > 1 else {
            self.efficiencyData = []
            return
        }

        for i in 1..<sortedSessions.count {
            let current = sortedSessions[i]
            let previous = sortedSessions[i-1]

            let distance = current.odometer - previous.odometer
            let energy = previous.energyAdded

            if distance > 0 && energy > 0 && !previous.isPartialCharge {
                let efficiency = distance / energy
                let dateString = current.date.formatted(.month.day())
                data.append((x: dateString, y: efficiency))
            }
        }

        self.efficiencyData = data
    }
}
