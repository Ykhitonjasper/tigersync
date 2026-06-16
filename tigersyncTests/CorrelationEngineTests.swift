import Foundation
import Testing
@testable import tigersync

@Suite("CorrelationEngine")
struct CorrelationEngineTests {
    @Test("finds pattern when signal and context repeat")
    func repeatedPattern() {
        let logs: [BehaviourLog] = [
            BehaviourLog(id: 1, petId: 1, signalIds: [1, 5], contextTagIds: [2], timestamp: Date(), note: ""),
            BehaviourLog(id: 2, petId: 1, signalIds: [1, 5], contextTagIds: [2], timestamp: Date(), note: ""),
            BehaviourLog(id: 3, petId: 1, signalIds: [9], contextTagIds: [2], timestamp: Date(), note: "")
        ]

        let results = CorrelationEngine.computeForPet(petId: 1, logs: logs)
        #expect(!results.isEmpty)
        let match = results.first { $0.contextTagIds.contains(2) && ($0.signalIds.contains(1) || $0.signalIds.contains(5)) }
        #expect(match != nil)
        #expect((match?.matchCount ?? 0) >= 2)
    }

    @Test("returns empty when insufficient logs")
    func insufficientData() {
        let logs: [BehaviourLog] = [
            BehaviourLog(id: 1, petId: 1, signalIds: [1], contextTagIds: [2], timestamp: Date(), note: "")
        ]
        let results = CorrelationEngine.computeForPet(petId: 1, logs: logs)
        #expect(results.isEmpty)
    }
}
