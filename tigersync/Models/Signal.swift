import Foundation

public enum SignalCategory: String, Codable, CaseIterable, Sendable {
    case tail, ears, vocal, posture

    public var displayName: String {
        switch self {
        case .tail: return "Tail"
        case .ears: return "Ears"
        case .vocal: return "Vocal"
        case .posture: return "Posture"
        }
    }

    public var icon: String {
        switch self {
        case .tail: return "arrow.left.and.right"
        case .ears: return "ear"
        case .vocal: return "waveform"
        case .posture: return "figure.stand"
        }
    }
}

public struct Signal: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public var category: SignalCategory
    public var name: String
    public var icon: String

    public init(id: Int, category: SignalCategory, name: String, icon: String) {
        self.id = id
        self.category = category
        self.name = name
        self.icon = icon
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
