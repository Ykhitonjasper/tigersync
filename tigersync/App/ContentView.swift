import SwiftUI

public struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    public init() {}

    public var body: some View {
        Group {
            if hasSeenOnboarding {
                RootTabView()
            } else {
                OnboardingScreen()
            }
        }
        .tint(AppTheme.accent)
        .onAppear {
            DispatchQueue.main.async {
                AnalyticsBootstrap.startAfterFirstFrameIfNeeded()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
