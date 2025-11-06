import SwiftUI

struct BannerImageView: View {
    var body: some View {
        Image(systemName: "car.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.deepForestGreen)
            .frame(height: 150)
            .padding()
    }
}
