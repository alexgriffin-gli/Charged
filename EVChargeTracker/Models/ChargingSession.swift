import Foundation

struct ChargingSession: Identifiable {
    let id: UUID
    var date: Date
    var odometer: Double
    var energyAdded: Double // in kWh
    var totalCost: Double
    var isPartialCharge: Bool
    var isMissedCharge: Bool
    var cityDrivingPercentage: Int
    var chargerType: String
    var location: String
    var paymentMethod: String
    var receipt: Data?
    var photos: [Data]?
    var chargingNetwork: String
    var tags: [String]?
}
