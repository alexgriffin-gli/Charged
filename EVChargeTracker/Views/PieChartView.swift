internal import SwiftUI

struct PieChartView: View {
    var cityPercentage: Double
    var highwayPercentage: Double

    var body: some View {
        HStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let radius = min(width, height) / 2

                ZStack {
                    Path { path in
                        path.move(to: center)
                        path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(cityPercentage * 3.6), clockwise: false)
                    }
                    .fill(Color.deepForestGreen)

                    Path { path in
                        path.move(to: center)
                        path.addArc(center: center, radius: radius, startAngle: .degrees(cityPercentage * 3.6), endAngle: .degrees(360), clockwise: false)
                    }
                    .fill(Color.gold)
                }
            }

            VStack(alignment: .leading) {
                Text("Driving Mix")
                    .font(.headline)
                HStack {
                    Rectangle()
                        .fill(Color.deepForestGreen)
                        .frame(width: 20, height: 20)
                    Text(String(format: "City: %.0f%%", cityPercentage))
                }
                HStack {
                    Rectangle()
                        .fill(Color.gold)
                        .frame(width: 20, height: 20)
                    Text(String(format: "Highway: %.0f%%", highwayPercentage))
                }
            }
        }
    }
}
