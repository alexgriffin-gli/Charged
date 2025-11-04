import Foundation
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var averageEfficiency: Double = 0
    @Published var lastEfficiency: Double = 0
    @Published var bestEfficiency: Double = 0
    @Published var totalMilesTracked: Double = 0
    @Published var cityDrivingPercentage: Double = 0
    @Published var highwayDrivingPercentage: Double = 0
    @Published var totalChargingSessions: Int = 0
    @Published var totalCost: Double = 0
    @Published var totalEnergy: Double = 0
    @Published var efficiencyData: [(x: String, y: Double)] = []

    func update(with vehicle: Vehicle) {
        let sessions = vehicle.chargingSessions.sorted { $0.odometer < $1.odometer }

        // Reset all values before recalculating
        resetValues()

        guard sessions.count > 1 else { return }

        totalChargingSessions = sessions.count
        totalCost = sessions.reduce(0) { $0 + $1.totalCost }
        totalEnergy = sessions.reduce(0) { $0 + $1.energyAdded }

        if let firstOdometer = sessions.first?.odometer, let lastOdometer = sessions.last?.odometer {
            totalMilesTracked = lastOdometer - firstOdometer
        }

        let efficiencies = calculateEfficiencies(from: sessions)

        if !efficiencies.isEmpty {
            averageEfficiency = efficiencies.map(\.y).reduce(0, +) / Double(efficiencies.count)
            lastEfficiency = efficiencies.last?.y ?? 0
            bestEfficiency = efficiencies.map(\.y).max() ?? 0
            efficiencyData = efficiencies
        }

        calculateDrivingPercentages(from: sessions)
    }

    private func calculateEfficiencies(from sessions: [ChargingSession]) -> [(x: String, y: Double)] {
        var results: [(x: String, y: Double)] = []
        guard sessions.count > 1 else { return results }

        for i in 1..<sessions.count {
            let currentSession = sessions[i]
            let previousSession = sessions[i-1]

            // Skip calculations if the previous charge was partial or missed
            if previousSession.isPartialCharge || previousSession.isMissedCharge {
                continue
            }

            let distance = currentSession.odometer - previousSession.odometer
            let energy = previousSession.energyAdded

            if distance > 0 && energy > 0 {
                let efficiency = distance / energy
                let dateString = currentSession.date.formatted(date: .numeric, time: .omitted)
                results.append((x: dateString, y: efficiency))
            }
        }
        return results
    }

    private func calculateDrivingPercentages(from sessions: [ChargingSession]) {
        guard totalMilesTracked > 0, sessions.count > 1 else { return }

        var totalCityMiles: Double = 0

        for i in 1..<sessions.count {
            let currentSession = sessions[i]
            let previousSession = sessions[i-1]

            let distance = currentSession.odometer - previousSession.odometer
            if distance > 0 {
                let cityRatio = Double(previousSession.cityDrivingPercentage) / 100.0
                totalCityMiles += distance * cityRatio
            }
        }

        cityDrivingPercentage = (totalCityMiles / totalMilesTracked) * 100
        highwayDrivingPercentage = 100 - cityDrivingPercentage
    }

    private func resetValues() {
        averageEfficiency = 0
        lastEfficiency = 0
        bestEfficiency = 0
        totalMilesTracked = 0
        cityDrivingPercentage = 0
        highwayDrivingPercentage = 0
        totalChargingSessions = 0
        totalCost = 0
        totalEnergy = 0
        efficiencyData = []
    }
}
