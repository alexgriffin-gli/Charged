import SwiftUI

struct DashboardGridView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            MetricCard(title: "AVG mi/KWH", value: String(format: "%.2f", viewModel.averageMilesPerKWh), symbolName: "speedometer")
            MetricCard(title: "TOTAL MILES TRACKED", value: String(format: "%.0f", viewModel.totalMilesDriven), symbolName: "road.lanes")
            MetricCard(title: "TOTAL COST", value: String(format: "$%.2f", viewModel.totalCost), symbolName: "dollarsign.circle")
            MetricCard(title: "TOTAL kWh", value: String(format: "%.2f", viewModel.totalKWh), symbolName: "bolt.leaf")
        }
        .padding()
    }
}
