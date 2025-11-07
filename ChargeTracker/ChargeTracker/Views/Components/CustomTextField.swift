import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
    }
}
