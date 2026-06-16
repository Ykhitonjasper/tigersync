import Foundation

public struct Correlation: Identifiable, Codable, Sendable {
    public let id: Int
    public var petId: Int
    public var signalIds: [Int]
    public var contextTagIds: [Int]
    public var matchCount: Int
    public var totalOpportunity: Int
    public var confidence: Double

    public init(id: Int, petId: Int, signalIds: [Int], contextTagIds: [Int], matchCount: Int, totalOpportunity: Int, confidence: Double) {
        self.id = id
        self.petId = petId
        self.signalIds = signalIds
        self.contextTagIds = contextTagIds
        self.matchCount = matchCount
        self.totalOpportunity = totalOpportunity
        self.confidence = confidence
    }

    public var confidencePercent: Int {
        Int(confidence * 100)
    }
}
