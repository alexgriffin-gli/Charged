internal import SwiftUI

struct TitledTextField<Field: Hashable>: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var focused: FocusState<Field?>.Binding
    var field: Field

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .focused(focused, equals: field)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.5), lineWidth: 1))
        }
    }
}
