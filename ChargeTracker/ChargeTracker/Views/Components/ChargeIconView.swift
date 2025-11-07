import SwiftUI

struct ChargeIconView: View {
    let chargerType: Int

    var body: some View {
        ZStack {
            Image(systemName: "bolt.fill")
                .font(.largeTitle)
                .foregroundColor(.yellow)

            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)

                Text("\(chargerType)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .offset(x: 15, y: -15)
        }
    }
}
