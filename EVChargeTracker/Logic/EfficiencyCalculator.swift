import Foundation

struct EfficiencyStats {
    let average: Double // mi/kWh
    let last: Double    // mi/kWh
    let best: Double    // mi/kWh
}

struct EfficiencyCalculator {

    /// Calculates efficiency stats from a list of charging sessions.
    ///
    /// - Note: This implementation calculates efficiency between each full charge.
    ///   It correctly handles partial charges by summing distance and energy
    ///   until the next non-partial charge is logged.
    ///
    /// - Parameter sessions: A list of charging sessions, sorted by date/odometer.
    /// - Returns: An `EfficiencyStats` object or `nil` if there aren't enough sessions.
    static func calculate(sessions: [ChargingSession]) -> EfficiencyStats? {
        // Ensure sessions are sorted by odometer for accurate calculations
        let sortedSessions = sessions.sorted { $0.odometer < $1.odometer }

        guard sortedSessions.count > 1 else {
            return nil // Not enough data to calculate efficiency
        }

        var efficiencies: [Double] = []

        for i in 1..<sortedSessions.count {
            let currentSession = sortedSessions[i]
            let previousSession = sortedSessions[i-1]

            // To calculate efficiency for a leg of a trip, we need the distance
            // driven and the energy consumed during that leg. The energy consumed
            // is the amount added at the *previous* charge.
            let distanceTraveled = currentSession.odometer - previousSession.odometer
            let energyUsed = previousSession.energyAdded // Corrected logic

            // We can only calculate efficiency if the previous charge was not a partial one
            // and the distance and energy are positive values.
            if !previousSession.isPartialCharge && distanceTraveled > 0 && energyUsed > 0 {
                let efficiency = distanceTraveled / energyUsed
                efficiencies.append(efficiency)
            }
        }

        guard !efficiencies.isEmpty else {
            return EfficiencyStats(average: 0, last: 0, best: 0)
        }

        let totalEfficiency = efficiencies.reduce(0, +)
        let averageEfficiency = totalEfficiency / Double(efficiencies.count)
        let lastEfficiency = efficiencies.last ?? 0
        let bestEfficiency = efficiencies.max() ?? 0

        return EfficiencyStats(
            average: averageEfficiency,
            last: lastEfficiency,
            best: bestEfficiency
        )
    }
}
