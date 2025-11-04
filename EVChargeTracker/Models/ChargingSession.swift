import Foundation

enum ChargerType: String, Codable, CaseIterable {
    case level1 = "Level 1"
    case level2 = "Level 2"
    case level3 = "Level 3"
}

enum LocationType: String, Codable, CaseIterable {
    case home = "Home"
    case work = "Work"
    case custom = "Custom"
}

struct ChargingSession: Identifiable, Codable {
    let id: UUID
    var date: Date
    var odometer: Double
    var energyAdded: Double
    var totalCost: Double
    var costPerKwh: Double
    var isPartialCharge: Bool
    var isMissedCharge: Bool
    var cityDrivingPercentage: Double
    var chargerType: ChargerType
    var location: LocationType
    var customLocation: String?
    var paymentMethod: String?
}
