import SwiftUI

struct PieChartView: View {
    var cityPercentage: Double
    var highwayPercentage: Double

    var body: some View {
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
                .fill(Color.teal)

                Path { path in
                    path.move(to: center)
                    path.addArc(center: center, radius: radius, startAngle: .degrees(cityPercentage * 3.6), endAngle: .degrees(360), clockwise: false)
                }
                .fill(Color.gold)

                VStack {
                    Text("Driving Mix")
                        .font(.headline)
                    Text(String(format: "City: %.0f%%", cityPercentage))
                    Text(String(format: "Highway: %.0f%%", highwayPercentage))
                }
            }
        }
    }
}
