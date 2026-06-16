import Foundation

public struct ContextTag: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public var name: String
    public var icon: String

    public init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
