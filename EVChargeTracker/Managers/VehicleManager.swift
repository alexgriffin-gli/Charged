import Foundation
import Combine

class VehicleManager: ObservableObject {
    @Published var vehicles: [Vehicle] = [] {
        didSet {
            save()
        }
    }
    @Published var currentVehicle: Vehicle? {
        didSet {
            saveCurrentVehicle()
        }
    }

    private let vehiclesSaveKey = "Vehicles_v2"
    private let currentVehicleSaveKey = "CurrentVehicle"

    init() {
        load()
        loadCurrentVehicle()
    }

    func add(vehicle: Vehicle) {
        vehicles.append(vehicle)
        if currentVehicle == nil {
            currentVehicle = vehicle
        }
    }

    func delete(vehicle: Vehicle) {
        vehicles.removeAll { $0.id == vehicle.id }
        if currentVehicle == vehicle {
            currentVehicle = vehicles.first
        }
    }

    func add(session: ChargingSession, to vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index].chargingSessions.append(session)
            vehicles[index].chargingSessions.sort { $0.odometer > $1.odometer }
        }
    }

    func deleteChargingSession(for vehicle: Vehicle, at offsets: IndexSet) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index].chargingSessions.remove(atOffsets: offsets)
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(vehicles) {
            UserDefaults.standard.set(encoded, forKey: vehiclesSaveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: vehiclesSaveKey) {
            if let decoded = try? JSONDecoder().decode([Vehicle].self, from: data) {
                self.vehicles = decoded
                return
            }
        }
        self.vehicles = []
    }

    private func saveCurrentVehicle() {
        if let vehicle = currentVehicle {
            UserDefaults.standard.set(vehicle.id.uuidString, forKey: currentVehicleSaveKey)
        } else {
            UserDefaults.standard.removeObject(forKey: currentVehicleSaveKey)
        }
    }

    private func loadCurrentVehicle() {
        if let vehicleIDString = UserDefaults.standard.string(forKey: currentVehicleSaveKey),
           let vehicleID = UUID(uuidString: vehicleIDString) {
            self.currentVehicle = vehicles.first { $0.id == vehicleID }
        } else if self.currentVehicle == nil {
            self.currentVehicle = vehicles.first
        }
    }
}
