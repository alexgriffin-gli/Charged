import SwiftUI

struct BarChartView: View {
    let data: [Double]

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(data.indices, id: \.self) { index in
                let value = data[index]
                let maxValue = data.max() ?? 1
                let normalizedHeight = CGFloat(value / maxValue)

                VStack {
                    Text(String(format: "%.1f", value))
                        .font(.caption)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: normalizedHeight * 100)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}
