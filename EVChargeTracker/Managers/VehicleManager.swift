import Foundation
import Combine

class VehicleManager: ObservableObject {
    @Published var vehicles: [Vehicle] = []

    private let vehiclesKey = "vehicles"

    init() {
        loadVehicles()
    }

    func addVehicle(name: String, make: String, model: String, year: Int?, trim: String?, vin: String?, bannerImageData: Data?) {
        let newVehicle = Vehicle(id: UUID(), name: name, make: make, model: model, year: year, trim: trim, vin: vin, bannerImageData: bannerImageData, chargingSessions: [])
        vehicles.append(newVehicle)
        saveVehicles()
    }

    func deleteVehicle(at offsets: IndexSet) {
        vehicles.remove(atOffsets: offsets)
        saveVehicles()
    }

    func addChargingSession(to vehicle: Vehicle, session: ChargingSession) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index].chargingSessions.append(session)
            saveVehicles()
        }
    }

    func deleteChargingSession(in vehicle: Vehicle, at offsets: IndexSet) {
        if let vehicleIndex = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[vehicleIndex].chargingSessions.remove(atOffsets: offsets)
            saveVehicles()
        }
    }

    private func saveVehicles() {
        if let encoded = try? JSONEncoder().encode(vehicles) {
            UserDefaults.standard.set(encoded, forKey: vehiclesKey)
        }
    }

    private func loadVehicles() {
        if let vehiclesData = UserDefaults.standard.data(forKey: vehiclesKey) {
            if let decodedVehicles = try? JSONDecoder().decode([Vehicle].self, from: vehiclesData) {
                vehicles = decodedVehicles
            }
        }
    }

    func exportToCSV() -> URL? {
        var csvString = "Vehicle,Date,Odometer,Energy Added (kWh),Total Cost,Partial Charge,Missed Charge,City Driving (%)\n"

        for vehicle in vehicles {
            for session in vehicle.chargingSessions {
                let dateString = session.date.formatted(date: .numeric, time: .omitted)
                let partialCharge = session.isPartialCharge ? "Yes" : "No"
                let missedCharge = session.isMissedCharge ? "Yes" : "No"

                let row = "\(vehicle.name),\(dateString),\(session.odometer),\(session.energyAdded),\(session.totalCost),\(partialCharge),\(missedCharge),\(session.cityDrivingPercentage)\n"
                csvString.append(row)
            }
        }

        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("charging_data.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error creating CSV file: \(error)")
            return nil
        }
    }
}
