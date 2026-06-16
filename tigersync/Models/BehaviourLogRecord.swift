import Foundation
import SwiftData

@Model
final class BehaviourLogRecord {
    @Attribute(.unique) var id: Int
    var petId: Int
    var signalIds: [Int]
    var contextTagIds: [Int]
    var timestamp: Date
    var note: String

    init(id: Int, petId: Int, signalIds: [Int], contextTagIds: [Int], timestamp: Date, note: String) {
        self.id = id
        self.petId = petId
        self.signalIds = signalIds
        self.contextTagIds = contextTagIds
        self.timestamp = timestamp
        self.note = note
    }

    func toBehaviourLog() -> BehaviourLog {
        BehaviourLog(
            id: id,
            petId: petId,
            signalIds: signalIds,
            contextTagIds: contextTagIds,
            timestamp: timestamp,
            note: note
        )
    }

    static func from(_ log: BehaviourLog) -> BehaviourLogRecord {
        BehaviourLogRecord(
            id: log.id,
            petId: log.petId,
            signalIds: log.signalIds,
            contextTagIds: log.contextTagIds,
            timestamp: log.timestamp,
            note: log.note
        )
    }
}
