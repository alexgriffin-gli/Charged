import SwiftUI
import Charts

struct EfficiencyGraphView: View {
    let efficiencyData: [(x: String, y: Double)]

    var body: some View {
        VStack {
            Text("Efficiency Over Time")
                .font(.headline)

            Chart {
                ForEach(efficiencyData, id: \.x) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.x),
                        y: .value("Efficiency (mi/kWh)", dataPoint.y)
                    )
                    .symbol(Circle().strokeBorder(lineWidth: 2))
                }
            }
            .frame(height: 200)
            .padding()
        }
    }
}

struct EfficiencyGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EfficiencyGraphView(efficiencyData: [("Jan 1", 3.5), ("Jan 2", 3.8)])
    }
}
