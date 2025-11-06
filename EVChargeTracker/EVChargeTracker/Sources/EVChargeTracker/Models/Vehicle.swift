import Foundation

struct Vehicle: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var make: String
    var model: String
    var year: Int
    var chargingSessions: [ChargingSession] = []

    var totalMilesDriven: Double {
        let sortedSessions = chargingSessions.sorted { $0.date < $1.date }
        guard let firstOdometer = sortedSessions.first?.odometer,
              let lastOdometer = sortedSessions.last?.odometer else {
            return 0
        }
        return lastOdometer - firstOdometer
    }

    var averageMilesPerKWh: Double {
        let totalKWh = chargingSessions.reduce(0) { $0 + $1.kwhAdded }
        if totalKWh > 0 {
            return totalMilesDriven / totalKWh
        } else {
            return 0
        }
    }
}
