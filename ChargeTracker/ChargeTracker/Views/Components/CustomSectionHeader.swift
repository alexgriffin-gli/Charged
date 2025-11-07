import SwiftUI

struct CustomSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.deepForestGreen)
            .padding(.top)
    }
}
