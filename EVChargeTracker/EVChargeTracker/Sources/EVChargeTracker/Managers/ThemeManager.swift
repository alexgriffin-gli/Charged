import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme = .light

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Load the saved color scheme or default to light mode
        if let savedScheme = UserDefaults.standard.string(forKey: "colorScheme") {
            if savedScheme == "dark" {
                self.colorScheme = .dark
            } else {
                self.colorScheme = .light
            }
        }

        // Save the color scheme whenever it changes
        $colorScheme
            .sink { scheme in
                UserDefaults.standard.set(scheme == .dark ? "dark" : "light", forKey: "colorScheme")
            }
            .store(in: &cancellables)
    }
}
