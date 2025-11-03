import SwiftUI

@main
struct EVChargeTrackerApp: App {
    @AppStorage("theme") private var selectedTheme: Theme = .system

    var body: some Scene {
        WindowGroup {
            MainView()
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
