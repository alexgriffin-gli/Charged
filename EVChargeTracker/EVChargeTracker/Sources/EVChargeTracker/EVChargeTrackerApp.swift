import SwiftUI

@main
struct EVChargeTrackerApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
