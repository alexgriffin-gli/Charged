import SwiftUI

struct MetricCard: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
