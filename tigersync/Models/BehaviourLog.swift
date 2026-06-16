import Foundation

public struct BehaviourLog: Identifiable, Codable, Sendable {
    public let id: Int
    public var petId: Int
    public var signalIds: [Int]
    public var contextTagIds: [Int]
    public var timestamp: Date
    public var note: String

    public init(id: Int, petId: Int, signalIds: [Int], contextTagIds: [Int], timestamp: Date, note: String) {
        self.id = id
        self.petId = petId
        self.signalIds = signalIds
        self.contextTagIds = contextTagIds
        self.timestamp = timestamp
        self.note = note
    }
}
