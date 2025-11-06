import SwiftUI

struct ContentView: View {
    @StateObject private var dashboardViewModel = DashboardViewModel()
    @State private var isSideMenuShowing = false

    var body: some View {
        ZStack {
            // Side Menu in the background
            SideMenuView(isShowing: $isSideMenuShowing)
                .environmentObject(dashboardViewModel)

            // Main content view with animation
            MainTabView(isSideMenuShowing: $isSideMenuShowing)
                .cornerRadius(isSideMenuShowing ? 20 : 0)
                .scaleEffect(isSideMenuShowing ? 0.85 : 1)
                .offset(x: isSideMenuShowing ? UIScreen.main.bounds.width * 0.8 : 0)
                .disabled(isSideMenuShowing)
        }
        .environmentObject(dashboardViewModel)
    }
}

struct MainTabView: View {
    @Binding var isSideMenuShowing: Bool
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView()
                    .navigationBarTitle("Dashboard")
                    .navigationBarItems(leading: Button(action: {
                        withAnimation(.spring()) {
                            isSideMenuShowing.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3").imageScale(.large)
                    })
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Dashboard")
            }
            .tag(0)

            NavigationView {
                HistoryView()
                    .navigationBarTitle("History")
                    .navigationBarItems(leading: Button(action: {
                        withAnimation(.spring()) {
                            isSideMenuShowing.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3").imageScale(.large)
                    })
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            .tag(1)
        }
    }
}
