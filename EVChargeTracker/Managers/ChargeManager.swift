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
