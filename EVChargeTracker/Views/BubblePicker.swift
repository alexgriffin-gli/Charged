internal import SwiftUI

struct BubblePicker<T: Hashable & RawRepresentable>: View where T.RawValue == String {
    var title: String
    @Binding var selection: T
    var options: [T]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(options, id: \.self) { option in
                        Button(action: { self.selection = option }) {
                            Text(option.rawValue)
                                .padding()
                                .background(self.selection == option ? Color.deepForestGreen : Color.gray.opacity(0.2))
                                .foregroundColor(self.selection == option ? .white : .primary)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}
