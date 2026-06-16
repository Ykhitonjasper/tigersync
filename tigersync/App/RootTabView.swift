import SwiftUI

public struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    public init() {}

    public var body: some View {
        RootTabContent(appState: appState)
    }
}

private struct RootTabContent: View {
    @StateObject private var dashboardVM: DashboardViewModel
    @StateObject private var petListVM: PetListViewModel
    @State private var selectedTab = 0

    init(appState: AppState) {
        _dashboardVM = StateObject(wrappedValue: DashboardViewModel(appState: appState))
        _petListVM = StateObject(wrappedValue: PetListViewModel(appState: appState))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardScreen(viewModel: dashboardVM)
            }
            .tabItem {
                Label("Journal", systemImage: "book")
            }
            .tag(0)
            .accessibilityIdentifier("tab.journal")

            NavigationStack {
                LearnHubScreen()
            }
            .tabItem {
                Label("Learn", systemImage: "graduationcap")
            }
            .tag(1)
            .accessibilityIdentifier("tab.learn")

            NavigationStack {
                PetListScreen(viewModel: petListVM)
            }
            .tabItem {
                Label("Pets", systemImage: "pawprint")
            }
            .tag(2)
            .accessibilityIdentifier("tab.pets")

            NavigationStack {
                SettingsScreen()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(3)
            .accessibilityIdentifier("tab.settings")
        }
        .tint(AppTheme.accent)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppState())
}
