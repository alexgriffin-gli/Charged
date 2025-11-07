import SwiftUI

struct HistoryRowView: View {
    let session: ChargingSession

    var body: some View {
        HStack {
            ChargeIconView(chargerType: session.chargerType)

            VStack(alignment: .leading) {
                Text(session.date, style: .date)
                    .font(.headline)
                Text("\(session.kwhAdded, specifier: "%.2f") kWh")
                    .font(.subheadline)
            }

            Spacer()

            Text("$\((session.pricePerKWh * session.kwhAdded), specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
