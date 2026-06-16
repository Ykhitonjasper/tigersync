import Foundation
import SwiftData

public actor StorageActor {
    public static let shared = StorageActor(container: StorageActor.makePersistentContainer())

    private struct LegacyStore: Codable {
        var pets: [Pet]
        var logs: [BehaviourLog]
    }

    private let container: ModelContainer
    private static let legacyFileName = "tattletail_store.json"

    public init(container: ModelContainer) {
        self.container = container
        Self.migrateLegacyJSONIfNeeded(into: container)
    }

    // MARK: - Container factories

    public static func makePersistentContainer() -> ModelContainer {
        let schema = Schema([PetRecord.self, BehaviourLogRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    public static func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([PetRecord.self, BehaviourLogRecord.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - Read

    public func loadPets() -> [Pet] {
        fetchPetRecords().map { $0.toPet() }
    }

    public func loadLogs() -> [BehaviourLog] {
        fetchLogRecords().map { $0.toBehaviourLog() }
    }

    public func loadLogs(for petId: Int) -> [BehaviourLog] {
        loadLogs()
            .filter { $0.petId == petId }
            .sorted { $0.timestamp > $1.timestamp }
    }

    public func loadCorrelations(for petId: Int) -> [Correlation] {
        CorrelationEngine.computeForPet(petId: petId, logs: loadLogs())
    }

    public func loadAllCorrelations() -> [Correlation] {
        let logs = loadLogs()
        let petIds = Set(logs.map(\.petId))
        var results: [Correlation] = []
        for petId in petIds {
            results.append(contentsOf: CorrelationEngine.computeForPet(petId: petId, logs: logs))
        }
        return results.sorted { $0.confidence > $1.confidence }
    }

    public func isEmpty() -> Bool {
        fetchPetRecords().isEmpty && fetchLogRecords().isEmpty
    }

    public func pet(for id: Int) -> Pet? {
        fetchPetRecords().first { $0.id == id }?.toPet()
    }

    // MARK: - Write

    public func saveLog(_ log: BehaviourLog) {
        let context = makeContext()
        let logId = log.id
        if let existing = try? context.fetch(FetchDescriptor<BehaviourLogRecord>(
            predicate: #Predicate { $0.id == logId }
        )).first {
            existing.petId = log.petId
            existing.signalIds = log.signalIds
            existing.contextTagIds = log.contextTagIds
            existing.timestamp = log.timestamp
            existing.note = log.note
        } else {
            context.insert(BehaviourLogRecord.from(log))
        }
        try? context.save()
    }

    public func savePet(_ pet: Pet) {
        let context = makeContext()
        let petId = pet.id
        if let existing = try? context.fetch(FetchDescriptor<PetRecord>(
            predicate: #Predicate { $0.id == petId }
        )).first {
            existing.update(from: pet)
        } else {
            context.insert(PetRecord.from(pet))
        }
        try? context.save()
    }

    public func deleteLog(id: Int) {
        let context = makeContext()
        let logId = id
        if let record = try? context.fetch(FetchDescriptor<BehaviourLogRecord>(
            predicate: #Predicate { $0.id == logId }
        )).first {
            context.delete(record)
            try? context.save()
        }
    }

    public func deletePet(id: Int) {
        let context = makeContext()
        let petId = id
        let pets = (try? context.fetch(FetchDescriptor<PetRecord>(
            predicate: #Predicate { $0.id == petId }
        ))) ?? []
        for pet in pets { context.delete(pet) }

        let logs = (try? context.fetch(FetchDescriptor<BehaviourLogRecord>(
            predicate: #Predicate { $0.petId == petId }
        ))) ?? []
        for log in logs { context.delete(log) }

        try? context.save()
    }

    public func loadSampleData() {
        clearAllData()
        for pet in MockData.pets { savePet(pet) }
        for log in MockData.logs { saveLog(log) }
    }

    public func clearAllData() {
        let context = makeContext()
        for record in fetchLogRecords(in: context) { context.delete(record) }
        for record in fetchPetRecords(in: context) { context.delete(record) }
        try? context.save()
    }

    public func nextLogId() -> Int {
        (fetchLogRecords().map(\.id).max() ?? 0) + 1
    }

    public func nextPetId() -> Int {
        (fetchPetRecords().map(\.id).max() ?? 0) + 1
    }

    // MARK: - Private

    private func makeContext() -> ModelContext {
        ModelContext(container)
    }

    private func fetchPetRecords(in context: ModelContext? = nil) -> [PetRecord] {
        let ctx = context ?? makeContext()
        let descriptor = FetchDescriptor<PetRecord>(sortBy: [SortDescriptor(\.id)])
        return (try? ctx.fetch(descriptor)) ?? []
    }

    private func fetchLogRecords(in context: ModelContext? = nil) -> [BehaviourLogRecord] {
        let ctx = context ?? makeContext()
        var descriptor = FetchDescriptor<BehaviourLogRecord>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        return (try? ctx.fetch(descriptor)) ?? []
    }

    private static func migrateLegacyJSONIfNeeded(into container: ModelContainer) {
        let context = ModelContext(container)
        let petCount = (try? context.fetchCount(FetchDescriptor<PetRecord>())) ?? 0
        let logCount = (try? context.fetchCount(FetchDescriptor<BehaviourLogRecord>())) ?? 0
        guard petCount == 0, logCount == 0 else { return }

        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = dir.appendingPathComponent(legacyFileName)
        guard let data = try? Data(contentsOf: fileURL),
              let store = try? JSONDecoder().decode(LegacyStore.self, from: data) else { return }

        for pet in store.pets {
            context.insert(PetRecord.from(pet))
        }
        for log in store.logs {
            context.insert(BehaviourLogRecord.from(log))
        }
        try? context.save()
        try? FileManager.default.removeItem(at: fileURL)
    }

    #if DEBUG
    public func resetForTesting() {
        clearAllData()
    }
    #endif
}
