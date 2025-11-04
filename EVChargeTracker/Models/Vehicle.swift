import Foundation
import SwiftUI

struct Vehicle: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var make: String
    var model: String
    var year: Int
    var trim: String
    var vin: String
    var bannerImageData: Data?
    var chargingSessions: [ChargingSession] = []

    var averageEfficiency: Double {
        let fullCharges = chargingSessions.filter { !$0.isPartialCharge && !$0.isMissedCharge }
        guard fullCharges.count > 1 else { return 0.0 }

        let sortedCharges = fullCharges.sorted { $0.odometer < $1.odometer }

        var totalDistance = 0.0
        var totalEnergy = 0.0

        for i in 0..<(sortedCharges.count - 1) {
            let distance = sortedCharges[i+1].odometer - sortedCharges[i].odometer
            totalDistance += distance
            totalEnergy += sortedCharges[i].energyAdded
        }

        return totalEnergy > 0 ? totalDistance / totalEnergy : 0.0
    }

    #if canImport(UIKit)
    var bannerImage: Image? {
        if let data = bannerImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    #endif

    func generateCSV() -> URL? {
        let fileName = "\(name.replacingOccurrences(of: " ", with: "_"))_charging_sessions.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        var csvText = "Date,Odometer,Energy Added (kWh),Total Cost,Partial Charge,Missed Charge,City Driving %,Charger Type,Location,Payment Method,Charging Network,Tags\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        for session in chargingSessions {
            let date = dateFormatter.string(from: session.date)
            let location = "\"\(session.location)\""
            let chargerType = "\"\(session.chargerType)\""
            let paymentMethod = "\"\(session.paymentMethod)\""
            let chargingNetwork = "\"\(session.chargingNetwork)\""
            let tags = "\"\(session.tags?.joined(separator: ",") ?? "")\""

            let newLine = "\(date),\(session.odometer),\(session.energyAdded),\(session.totalCost),\(session.isPartialCharge),\(session.isMissedCharge),\(session.cityDrivingPercentage),\(chargerType),\(location),\(paymentMethod),\(chargingNetwork),\(tags)\n"
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
}
