import Foundation
import Testing
@testable import tigersync

@Suite("StorageActor")
struct StorageActorTests {
    private func makeStorage() throws -> StorageActor {
        let container = try StorageActor.makeInMemoryContainer()
        let storage = StorageActor(container: container)
        return storage
    }

    @Test("persists pets and logs in SwiftData")
    func persistenceRoundTrip() async throws {
        let storage = try makeStorage()
        await storage.resetForTesting()

        let pet = Pet(id: 1, name: "TestDog", species: .dog, breed: "Mix", colorHex: "#F4A460")
        await storage.savePet(pet)

        let log = BehaviourLog(
            id: 1,
            petId: 1,
            signalIds: [1, 5],
            contextTagIds: [2],
            timestamp: Date(timeIntervalSince1970: 1_700_000_000),
            note: "Test note"
        )
        await storage.saveLog(log)

        let reloadedPets = await storage.loadPets()
        let reloadedLogs = await storage.loadLogs()

        #expect(reloadedPets.count == 1)
        #expect(reloadedPets.first?.name == "TestDog")
        #expect(reloadedLogs.count == 1)
        #expect(reloadedLogs.first?.note == "Test note")
    }

    @Test("computes correlations from saved logs")
    func correlationsRecompute() async throws {
        let storage = try makeStorage()
        await storage.resetForTesting()

        let pet = Pet(id: 1, name: "Buddy", species: .dog, breed: "Mix", colorHex: "#F4A460")
        await storage.savePet(pet)

        for index in 0..<3 {
            let log = BehaviourLog(
                id: index + 1,
                petId: 1,
                signalIds: [1, 5],
                contextTagIds: [2],
                timestamp: Date().addingTimeInterval(Double(-index * 3600)),
                note: ""
            )
            await storage.saveLog(log)
        }

        let correlations = await storage.loadCorrelations(for: 1)
        #expect(!correlations.isEmpty)
        #expect(correlations.first?.petId == 1)
    }

    @Test("delete log removes entry")
    func deleteLog() async throws {
        let storage = try makeStorage()
        await storage.resetForTesting()

        let log = BehaviourLog(id: 1, petId: 1, signalIds: [1], contextTagIds: [2], timestamp: Date(), note: "")
        await storage.saveLog(log)
        await storage.deleteLog(id: 1)

        #expect(await storage.loadLogs().isEmpty)
    }
}
