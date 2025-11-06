import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var chartData: [Double] = []
    @Published var bestMiKWh: Double = 0
    @Published var lastMiKWh: Double = 0

    func updateChartData(with vehicle: Vehicle?) {
        guard let vehicle = vehicle else {
            chartData = []
            bestMiKWh = 0
            lastMiKWh = 0
            return
        }

        let sortedSessions = vehicle.chargingSessions.sorted { $0.date > $1.date }
        let recentSessions = Array(sortedSessions.prefix(10))

        let efficiencies = recentSessions.compactMap { session -> Double? in
            guard let miles = session.milesDriven, miles > 0, session.kwhAdded > 0 else { return nil }
            return miles / session.kwhAdded
        }

        chartData = efficiencies.reversed() // Show oldest to newest

        bestMiKWh = efficiencies.max() ?? 0

        if let lastSession = recentSessions.first, let miles = lastSession.milesDriven, miles > 0, lastSession.kwhAdded > 0 {
            lastMiKWh = miles / lastSession.kwhAdded
        } else {
            lastMiKWh = 0
        }
    }
}
