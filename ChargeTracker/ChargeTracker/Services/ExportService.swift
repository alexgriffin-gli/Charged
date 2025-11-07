import Foundation

class ExportService {

    func generateCSV(for vehicle: Vehicle) -> URL? {
        let fileName = "\(vehicle.name)_charging_history.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        var csvText = "Date,Odometer,kWh Added,Price per kWh,Total Cost,Charge Percentage,Is Full Charge,Location,Payment Method,Charging Network\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        for session in vehicle.chargingSessions {
            let date = dateFormatter.string(from: session.date)
            let odometer = "\(session.odometer)"
            let kwhAdded = "\(session.kwhAdded)"
            let pricePerKWh = "\(session.pricePerKWh)"
            let totalCost = "\(session.kwhAdded * session.pricePerKWh)"
            let chargePercentage = "\(session.chargePercentage)"
            let isFullCharge = "\(session.isFullCharge)"
            let location = session.location
            let paymentMethod = session.paymentMethod
            let chargingNetwork = session.chargingNetwork

            let row = "\(date),\(odometer),\(kwhAdded),\(pricePerKWh),\(totalCost),\(chargePercentage),\(isFullCharge),\(location),\(paymentMethod),\(chargingNetwork)\n"
            csvText.append(row)
        }

        do {
            try csvText.write(to: path!, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to create file: \(error)")
            return nil
        }
    }
}
