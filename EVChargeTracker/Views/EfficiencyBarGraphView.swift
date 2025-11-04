internal import SwiftUI

struct EfficiencyBarGraphView: View {
    var efficiencies: [Double]

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<efficiencies.count, id: \.self) { index in
                VStack {
                    Text(String(format: "%.1f", efficiencies[index]))
                        .font(.caption)
                    Rectangle()
                        .fill(Color.deepForestGreen)
                        .frame(height: efficiencies[index] * 10) // Scale the height
                }
            }
        }
    }
}
