import SwiftUI
import SwiftData

@main
struct TigersyncApp: App {
    @State private var appState = AppState()

    init() {
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .modelContainer(appState.modelContainer)
                .task {
                    if ProcessInfo.processInfo.arguments.contains("UI-Fresh") {
                        await appState.storage.clearAllData()
                        appState.notifyDataChanged()
                    }
                }
        }
    }
}
