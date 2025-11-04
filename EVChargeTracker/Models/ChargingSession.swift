import Foundation

struct ChargingSession: Identifiable, Codable {
    let id: UUID
    var date: Date
    var odometer: Double
    var energyAdded: Double
    var totalCost: Double
    var isPartialCharge: Bool
    var isMissedCharge: Bool
    var cityDrivingPercentage: Int
    var chargerType: String?
    var location: String?
}
