import SwiftUI
import Charts

struct EfficiencyGraphView: View {
    let efficiencyData: [(x: String, y: Double)]

    var body: some View {
        Chart {
            ForEach(efficiencyData, id: \.x) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.x),
                    y: .value("mi/kWh", dataPoint.y)
                )
                .foregroundStyle(Color.teal)

                PointMark(
                    x: .value("Date", dataPoint.x),
                    y: .value("mi/kWh", dataPoint.y)
                )
                .foregroundStyle(Color.teal)
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing)
        }
        .chartXAxis(.hidden)
        .frame(height: 150)
    }
}

struct EfficiencyGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EfficiencyGraphView(efficiencyData: [
            (x: "1/1", y: 3.5),
            (x: "1/8", y: 3.8),
            (x: "1/15", y: 3.6),
            (x: "1/22", y: 4.1),
            (x: "1/29", y: 3.9)
        ])
        .padding()
    }
}
