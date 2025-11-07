import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var totalCost: String = "" { didSet { calculate() } }
    @Published var kwhAdded: String = "" { didSet { calculate() } }
    @Published var pricePerKWh: String = "" { didSet { calculate() } }

    private var isCalculating = false

    private func calculate() {
        guard !isCalculating else { return }
        isCalculating = true

        let cost = Double(totalCost)
        let kwh = Double(kwhAdded)
        let price = Double(pricePerKWh)

        // Count how many fields are filled
        let filledCount = [cost, kwh, price].compactMap { $0 }.count

        if filledCount == 2 {
            if totalCost.isEmpty, let kwh = kwh, let price = price {
                totalCost = String(format: "%.2f", kwh * price)
            } else if kwhAdded.isEmpty, let cost = cost, let price = price, price > 0 {
                kwhAdded = String(format: "%.2f", cost / price)
            } else if pricePerKWh.isEmpty, let cost = cost, let kwh = kwh, kwh > 0 {
                pricePerKWh = String(format: "%.2f", cost / kwh)
            }
        }

        DispatchQueue.main.async {
            self.isCalculating = false
        }
    }
}
