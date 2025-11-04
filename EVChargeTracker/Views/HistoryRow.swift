internal import SwiftUI

struct HistoryRow: View {
    let session: ChargingSession

    var body: some View {
        HStack {
            Image(systemName: icon(for: session.chargerType))
                .foregroundColor(.deepForestGreen)
                .frame(width: UIScreen.main.bounds.width * 0.1)

            VStack(alignment: .leading) {
                Text(session.date, style: .date)
                    .font(.headline)
                Text(String(format: "%.2f kWh for $%.2f", session.energyAdded, session.totalCost))
                Text(session.location.rawValue)
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)

            Spacer()

            Text(String(format: "%.2f", session.costPerKwh))
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width * 0.2)
        }
        .padding(.vertical, 8)
    }

    private func icon(for chargerType: ChargerType) -> String {
        switch chargerType {
        case .level1:
            return "bolt"
        case .level2:
            return "bolt.fill"
        case .level3:
            return "bolt.badge.a"
        }
    }
}
