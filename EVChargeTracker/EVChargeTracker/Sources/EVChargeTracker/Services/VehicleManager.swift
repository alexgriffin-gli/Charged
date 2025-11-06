import Foundation
import Combine

class VehicleManager: ObservableObject {
    static let shared = VehicleManager()

    @Published var vehicles: [Vehicle] = [] {
        didSet {
            saveVehicles()
        }
    }

    private let vehiclesKey = "vehicles"

    private init() {
        loadVehicles()
    }

    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
    }

    func updateVehicle(_ vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index] = vehicle
            recalculateMilesDriven(forVehicleAtIndex: index)
        }
    }

    func deleteVehicle(at offsets: IndexSet) {
        vehicles.remove(atOffsets: offsets)
    }

    func addChargingSession(to vehicleId: UUID, session: ChargingSession) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicleId }) {
            vehicles[index].chargingSessions.append(session)
            recalculateMilesDriven(forVehicleAtIndex: index)
        }
    }

    func updateChargingSession(for vehicleId: UUID, session: ChargingSession) {
        if let vehicleIndex = vehicles.firstIndex(where: { $0.id == vehicleId }) {
            if let sessionIndex = vehicles[vehicleIndex].chargingSessions.firstIndex(where: { $0.id == session.id }) {
                vehicles[vehicleIndex].chargingSessions[sessionIndex] = session
                recalculateMilesDriven(forVehicleAtIndex: vehicleIndex)
            }
        }
    }

    private func recalculateMilesDriven(forVehicleAtIndex index: Int) {
        var vehicle = vehicles[index]
        let sortedSessions = vehicle.chargingSessions.sorted { $0.date < $1.date }

        for i in 0..<sortedSessions.count {
            if i > 0 {
                let currentOdometer = sortedSessions[i].odometer
                let previousOdometer = sortedSessions[i-1].odometer
                let miles = currentOdometer - previousOdometer

                if let sessionIndex = vehicle.chargingSessions.firstIndex(where: { $0.id == sortedSessions[i].id }) {
                    vehicle.chargingSessions[sessionIndex].milesDriven = miles > 0 ? miles : 0
                }
            } else {
                if let sessionIndex = vehicle.chargingSessions.firstIndex(where: { $0.id == sortedSessions[i].id }) {
                    vehicle.chargingSessions[sessionIndex].milesDriven = 0
                }
            }
        }
        vehicles[index] = vehicle
    }

    private func saveVehicles() {
        if let encoded = try? JSONEncoder().encode(vehicles) {
            UserDefaults.standard.set(encoded, forKey: vehiclesKey)
        }
    }

    private func loadVehicles() {
        if let data = UserDefaults.standard.data(forKey: vehiclesKey) {
            if let decoded = try? JSONDecoder().decode([Vehicle].self, from: data) {
                vehicles = decoded
                return
            }
        }
        vehicles = []
    }
}
