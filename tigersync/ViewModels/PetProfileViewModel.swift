import SwiftUI

@MainActor
final public class PetProfileViewModel: ObservableObject {
    @Published public var pet: Pet
    @Published public var logs: [BehaviourLog] = []
    @Published public var correlations: [Correlation] = []
    @Published public private(set) var topSignal: Signal?
    @Published public private(set) var topContext: ContextTag?

    private let appState: AppState

    public init(pet: Pet, appState: AppState) {
        self.pet = pet
        self.appState = appState
    }

    public func load() async {
        if let updated = await appState.storage.pet(for: pet.id) {
            pet = updated
        }
        logs = await appState.storage.loadLogs(for: pet.id)
        correlations = await appState.storage.loadCorrelations(for: pet.id)
        topSignal = computeTopSignal()
        topContext = computeTopContext()
    }

    public func deleteLog(id: Int) async {
        await appState.storage.deleteLog(id: id)
        appState.notifyDataChanged()
        await load()
    }

    private func computeTopSignal() -> Signal? {
        let signalCounts = Dictionary(grouping: logs.flatMap { $0.signalIds }) { $0 }
        let topId = signalCounts.max { $0.value.count < $1.value.count }?.key
        return MockData.signals.first(where: { $0.id == topId })
    }

    private func computeTopContext() -> ContextTag? {
        let contextCounts = Dictionary(grouping: logs.flatMap { $0.contextTagIds }) { $0 }
        let topId = contextCounts.max { $0.value.count < $1.value.count }?.key
        return MockData.contextTags.first(where: { $0.id == topId })
    }
}
