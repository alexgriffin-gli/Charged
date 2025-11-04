import SwiftUI

struct PieChartView: View {
    let cityPercentage: Double
    let highwayPercentage: Double

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: CGFloat(cityPercentage / 100))
                    .stroke(Color.deepYellowGold, lineWidth: 20)
                Circle()
                    .trim(from: CGFloat(cityPercentage / 100), to: 1)
                    .stroke(Color.deepForestGreen, lineWidth: 20)
            }
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(-90))

            HStack {
                Circle()
                    .fill(Color.deepYellowGold)
                    .frame(width: 10, height: 10)
                Text("City")

                Circle()
                    .fill(Color.deepForestGreen)
                    .frame(width: 10, height: 10)
                Text("Highway")
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(cityPercentage: 60, highwayPercentage: 40)
    }
}
