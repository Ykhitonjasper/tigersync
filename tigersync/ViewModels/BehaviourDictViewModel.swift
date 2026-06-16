import SwiftUI

@MainActor
final public class BehaviourDictViewModel: ObservableObject {
    @Published public var correlations: [Correlation] = []
    @Published public var logs: [BehaviourLog] = []

    private let appState: AppState
    public let pet: Pet

    public init(pet: Pet, appState: AppState) {
        self.pet = pet
        self.appState = appState
    }

    public func load() async {
        correlations = await appState.storage.loadCorrelations(for: pet.id)
        logs = await appState.storage.loadLogs(for: pet.id)
    }

    public func signals(for ids: [Int]) -> [Signal] {
        MockData.signals(for: ids)
    }

    public func contexts(for ids: [Int]) -> [ContextTag] {
        MockData.contextTags(for: ids)
    }

    public func matchingLogs(for correlation: Correlation) -> [BehaviourLog] {
        logs.filter { log in
            Set(log.signalIds).isSuperset(of: Set(correlation.signalIds)) &&
            Set(log.contextTagIds).isSuperset(of: Set(correlation.contextTagIds))
        }
    }
}
