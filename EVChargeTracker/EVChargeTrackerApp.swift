import SwiftUI

@main
struct EVChargeTrackerApp: App {
    @StateObject private var vehicleManager = VehicleManager()
    @AppStorage("theme") private var selectedTheme: Theme = .system

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vehicleManager)
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
