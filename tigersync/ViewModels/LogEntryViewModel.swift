import SwiftUI

@MainActor
final public class LogEntryViewModel: ObservableObject {
    @Published public var selectedPetId: Int?
    @Published public var selectedSignals: [Signal] = []
    @Published public var selectedContexts: [ContextTag] = []
    @Published public var note: String = ""
    @Published public var timestamp: Date = Date()
    @Published public var isShowingSignalPicker = false
    @Published public var isShowingContextPicker = false
    @Published public private(set) var pets: [Pet] = []

    public let allSignals: [Signal] = MockData.signals
    public let allContexts: [ContextTag] = MockData.contextTags

    private let appState: AppState

    public init(appState: AppState) {
        self.appState = appState
    }

    public func load() async {
        pets = await appState.storage.loadPets()
        if selectedPetId == nil {
            selectedPetId = pets.first?.id
        }
    }

    public var selectedPet: Pet? {
        guard let selectedPetId else { return nil }
        return pets.first(where: { $0.id == selectedPetId })
    }

    public var canSave: Bool {
        selectedPetId != nil && !selectedSignals.isEmpty && !selectedContexts.isEmpty
    }

    public func clear() {
        selectedPetId = pets.first?.id
        selectedSignals = []
        selectedContexts = []
        note = ""
        timestamp = Date()
    }
}
