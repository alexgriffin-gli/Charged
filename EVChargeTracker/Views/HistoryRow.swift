internal import SwiftUI

struct HistoryRow: View {
    let session: ChargingSession

    var body: some View {
        HStack {
            Image(systemName: icon(for: session.chargerType))
                .foregroundColor(.deepForestGreen)
                .frame(width: 30) // Fixed width for the icon container

            VStack(alignment: .leading) {
                Text(session.date, style: .date)
                    .font(.headline)
                Text(String(format: "%.2f kWh for $%.2f", session.energyAdded, session.totalCost))
                    .font(.subheadline)
                Text(session.location.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(String(format: "$%.2f/kWh", session.costPerKwh))
                .font(.caption.bold())
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
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
