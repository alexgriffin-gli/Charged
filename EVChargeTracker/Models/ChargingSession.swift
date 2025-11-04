import Foundation

struct ChargingSession: Identifiable, Codable, Equatable, Hashable {
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
    var chargingNetwork: String
    var tags: [String]?
}
