import SwiftUI

struct LightningChargeView: View {
    @Binding var chargePercentage: Double

    var body: some View {
        HStack {
            Image(systemName: "bolt.fill")
                .font(.largeTitle)
                .foregroundColor(.yellow)

            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)

                Text("\(Int(chargePercentage))%")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Slider(value: $chargePercentage, in: 0...100, step: 1)
        }
    }
}
