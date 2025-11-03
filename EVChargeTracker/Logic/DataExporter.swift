import Foundation

struct DataExporter {

    /// Converts an array of charging sessions into a CSV formatted string.
    ///
    /// - Parameter sessions: The charging sessions to export.
    /// - Returns: A string in CSV format.
    static func exportToCSV(sessions: [ChargingSession]) -> String {
        var csvString = "Date,Odometer,EnergyAdded,TotalCost,IsPartialCharge,IsMissedCharge,CityDrivingPercentage,ChargerType,Location,PaymentMethod,ChargingNetwork,Tags\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        for session in sessions {
            let date = dateFormatter.string(from: session.date)
            let odometer = String(session.odometer)
            let energyAdded = String(session.energyAdded)
            let totalCost = String(session.totalCost)
            let isPartialCharge = String(session.isPartialCharge)
            let isMissedCharge = String(session.isMissedCharge)
            let cityDriving = String(session.cityDrivingPercentage)
            let chargerType = session.chargerType
            let location = session.location
            let paymentMethod = session.paymentMethod
            let chargingNetwork = session.chargingNetwork
            let tags = session.tags?.joined(separator: ";") ?? ""

            let row = "\(date),\(odometer),\(energyAdded),\(totalCost),\(isPartialCharge),\(isMissedCharge),\(cityDriving),\"\(chargerType)\",\"\(location)\",\"\(paymentMethod)\",\"\(chargingNetwork)\",\"\(tags)\"\n"
            csvString.append(row)
        }

        return csvString
    }
}
