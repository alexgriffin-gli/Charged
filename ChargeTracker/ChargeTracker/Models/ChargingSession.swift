import Foundation

struct ChargingSession: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    var date: Date
    var odometer: Double
    var pricePerKWh: Double
    var kwhAdded: Double
    var chargePercentage: Double
    var isFullCharge: Bool
    var location: String
    var paymentMethod: String
    var chargingNetwork: String
    var isMissedCharge: Bool = false
    var chargerType: Int = 2 // Default to Level 2

    var milesDriven: Double?
}
