import SwiftUI

struct CustomDatePicker: View {
    let title: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
        }
        .padding()
    }
}
