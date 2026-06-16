import SwiftData
import SwiftUI

@MainActor
public class AppState: ObservableObject {
    @Published public var dataVersion: Int = 0

    public let modelContainer: ModelContainer
    public let storage: StorageActor

    public init(modelContainer: ModelContainer? = nil) {
        let container = modelContainer ?? StorageActor.makePersistentContainer()
        self.modelContainer = container
        self.storage = StorageActor(container: container)
    }

    public static func inMemoryForTesting() throws -> AppState {
        AppState(modelContainer: try StorageActor.makeInMemoryContainer())
    }

    public func notifyDataChanged() {
        dataVersion += 1
    }
}
