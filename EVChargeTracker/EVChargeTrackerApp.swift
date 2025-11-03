import SwiftUI

@main
struct EVChargeTrackerApp: App {
    @StateObject private var chargeManager = ChargeManager()
    @AppStorage("theme") private var selectedTheme: Theme = .system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chargeManager)
                .preferredColorScheme(colorScheme)
        }
    }

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.high")
                }

            LogHistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
