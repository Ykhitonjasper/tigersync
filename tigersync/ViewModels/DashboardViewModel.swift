import SwiftUI

@MainActor
final public class DashboardViewModel: ObservableObject {
    @Published public var recentLogs: [BehaviourLog] = []
    @Published public var pets: [Pet] = []
    @Published public var totalLogCount = 0
    @Published public var patternCount = 0
    @Published public var logCountsByPetId: [Int: Int] = [:]
    @Published public var isShowingLogEntry = false
    @Published public var isEmpty = false

    private let appState: AppState

    public init(appState: AppState) {
        self.appState = appState
    }

    public func load() async {
        pets = await appState.storage.loadPets()
        let logs = await appState.storage.loadLogs()
        recentLogs = Array(logs.prefix(10))
        totalLogCount = logs.count
        patternCount = await appState.storage.loadAllCorrelations().count
        logCountsByPetId = Dictionary(grouping: logs, by: \.petId).mapValues(\.count)
        isEmpty = await appState.storage.isEmpty()
    }

    public func addLog(
        signals: [Signal],
        contexts: [ContextTag],
        petId: Int,
        note: String,
        timestamp: Date
    ) async {
        let id = await appState.storage.nextLogId()
        let log = BehaviourLog(
            id: id,
            petId: petId,
            signalIds: signals.map(\.id),
            contextTagIds: contexts.map(\.id),
            timestamp: timestamp,
            note: note
        )
        await appState.storage.saveLog(log)
        appState.notifyDataChanged()
        await load()
    }

    public func loadSampleData() async {
        await appState.storage.loadSampleData()
        appState.notifyDataChanged()
        await load()
    }

    public func petName(for petId: Int) -> String {
        pets.first(where: { $0.id == petId })?.name ?? "Unknown"
    }

    public func petColor(for petId: Int) -> Color {
        guard let hex = pets.first(where: { $0.id == petId })?.colorHex else { return .accentColor }
        return Color(hex: hex)
    }

    public func pet(for petId: Int) -> Pet? {
        pets.first(where: { $0.id == petId })
    }
}
