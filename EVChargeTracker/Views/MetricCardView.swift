import SwiftUI

struct MetricCardView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            content
                .font(.largeTitle)
                .foregroundColor(.deepForestGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

struct MetricCardView_Previews: PreviewProvider {
    static var previews: some View {
        MetricCardView(title: "AVG mi/KWH") {
            Text("3.8")
        }
        .padding()
    }
}
