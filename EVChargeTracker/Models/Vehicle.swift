import Foundation

struct Vehicle: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var make: String
    var model: String
    var year: Int
    var trim: String
    var vin: String
    var bannerImageData: Data?
    var chargingSessions: [ChargingSession]
}
