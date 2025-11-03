import Combine
import Foundation

class ChargeManager: ObservableObject {
    @Published var sessions: [ChargingSession] = [] {
        didSet {
            save()
        }
    }

    private let saveKey = "ChargingSessions"

    init() {
        load()
    }

    func add(session: ChargingSession) {
        sessions.append(session)
        sessions.sort { $0.odometer > $1.odometer }
    }

    func delete(session: ChargingSession) {
        sessions.removeAll { $0.id == session.id }
    }

    // MARK: - Statistics

    var totalEnergy: Double {
        sessions.map(\.energyAdded).reduce(0, +)
    }

    var totalCost: Double {
        sessions.map(\.totalCost).reduce(0, +)
    }

    var averageEfficiency: Double {
        let fullCharges = sessions.filter { !$0.isPartialCharge && !$0.isMissedCharge }
        guard fullCharges.count > 1 else { return 0.0 }

        let sortedCharges = fullCharges.sorted { $0.odometer < $1.odometer }

        var totalDistance = 0.0
        var totalEnergy = 0.0

        for i in 0..<(sortedCharges.count - 1) {
            let distance = sortedCharges[i+1].odometer - sortedCharges[i].odometer
            totalDistance += distance
            totalEnergy += sortedCharges[i+1].energyAdded
        }

        return totalEnergy > 0 ? (totalEnergy / totalDistance) * 100 : 0.0
    }

    // MARK: - Data Export

    func generateCSV() -> URL? {
        let fileName = "charging_sessions.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        var csvText = "Date,Odometer,Energy Added (kWh),Total Cost,Charger Type,Location\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        for session in sessions {
            let date = dateFormatter.string(from: session.date)
            let location = "\"\(session.location)\""
            let chargerType = "\"\(session.chargerType)\""
            let newLine = "\(date),\(session.odometer),\(session.energyAdded),\(session.totalCost),\(chargerType),\(location)\n"
            csvText.append(newLine)
        }

        do {
            try csvText.write(to: path!, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to create file: \(error)")
            return nil
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([ChargingSession].self, from: data) {
                self.sessions = decoded
                return
            }
        }
        self.sessions = []
    }
}

// Make ChargingSession Codable for saving to UserDefaults
extension ChargingSession: Codable {}
