import SwiftUI

struct EfficiencyGraphView: View {
    var data: [(x: String, y: Double)]

    var body: some View {
        VStack {
            Text("Efficiency Over Time")
                .font(.headline)

            if data.isEmpty {
                Text("Not enough data to display graph.")
            } else {
                VStack {
                    HStack(spacing: 8) {
                        // Y-axis labels
                        VStack {
                            let maxY = data.map(\.y).max() ?? 1
                            Text(String(format: "%.1f", maxY))
                            Spacer()
                            Text(String(format: "%.1f", maxY / 2))
                            Spacer()
                            Text("0.0")
                        }
                        .font(.caption)
                        .frame(width: 40)

                        // Graph
                        GeometryReader { geometry in
                            let maxX = data.count > 1 ? data.count - 1 : 1
                            let maxY = data.map(\.y).max() ?? 1

                            ZStack {
                                // Axis borders
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: 0))
                                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                                }
                                .stroke(Color.gray, lineWidth: 1)

                                // Graph path
                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let xPosition = geometry.size.width * CGFloat(index) / CGFloat(maxX)
                                        let yPosition = geometry.size.height * (1 - CGFloat(point.y / maxY))

                                        if index == 0 {
                                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                                        } else {
                                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                                        }
                                    }
                                }
                                .stroke(Color.deepForestGreen, lineWidth: 2)

                                // Data points
                                ForEach(0..<data.count, id: \.self) { index in
                                    let point = data[index]
                                    let xPosition = geometry.size.width * CGFloat(index) / CGFloat(maxX)
                                    let yPosition = geometry.size.height * (1 - CGFloat(point.y / maxY))

                                    Circle()
                                        .fill(Color.deepForestGreen)
                                        .frame(width: 8, height: 8)
                                        .position(x: xPosition, y: yPosition)
                                }
                            }
                        }
                    }

                    // X-axis labels
                    HStack {
                        ForEach(data, id: \.x) { point in
                            Text(point.x)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.leading, 48) // Align with the graph
                }
            }
        }
    }
}
