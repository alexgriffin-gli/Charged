import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1)
    }
}
