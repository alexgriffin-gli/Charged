import SwiftUI

struct MainView: View {
    @StateObject private var chargeManager = ChargeManager()

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.xaxis")
                }
                .environmentObject(chargeManager)

            ChargingHistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
                .environmentObject(chargeManager)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .environmentObject(chargeManager)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
