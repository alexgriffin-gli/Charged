import Foundation

struct Vehicle: Identifiable {
    let id: UUID
    var name: String
    var make: String
    var model: String
    var odometer: Double
}
