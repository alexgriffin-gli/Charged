import SwiftUI

struct DetailedSessionView: View {
    var session: ChargingSession

    var body: some View {
        Form {
            Section(header: Text("Session Details")) {
                LabeledContent("Date", value: session.date.formatted(date: .long, time: .omitted))
                LabeledContent("Odometer", value: String(format: "%.0f miles", session.odometer))
            }

            Section(header: Text("Charging Stats")) {
                LabeledContent("Energy Added", value: String(format: "%.2f kWh", session.energyAdded))
                LabeledContent("Total Cost", value: String(format: "$%.2f", session.totalCost))
                if let chargerType = session.chargerType, !chargerType.isEmpty {
                    LabeledContent("Charger Type", value: chargerType)
                }
            }

            Section(header: Text("Driving Context")) {
                LabeledContent("City Driving", value: "\(session.cityDrivingPercentage)%")
                if let location = session.location, !location.isEmpty {
                    LabeledContent("Location", value: location)
                }
            }

            Section(header: Text("Flags")) {
                if session.isPartialCharge {
                    Label("Partial Charge", systemImage: "flag.fill")
                }
                if session.isMissedCharge {
                    Label("Missed Charge", systemImage: "flag.fill")
                }
                if !session.isPartialCharge && !session.isMissedCharge {
                    Text("No flags for this session.")
                }
            }
        }
        .navigationTitle("Session Details")
    }
}

// Helper for iOS versions before 16
struct LabeledContent<Content: View>: View {
    var title: LocalizedStringKey
    var content: Content

    init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            content
                .foregroundColor(.secondary)
        }
    }
}

extension LabeledContent where Content == Text {
    init(_ title: LocalizedStringKey, value: String) {
        self.init(title) {
            Text(value)
        }
    }
}
