import Foundation

public enum PetSpecies: String, Codable, CaseIterable, Sendable {
    case dog, cat, bird, rabbit, other

    public var icon: String {
        switch self {
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .rabbit: return "hare.fill"
        case .other: return "pawprint.fill"
        }
    }
}

public struct Pet: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public var name: String
    public var species: PetSpecies
    public var breed: String
    public var colorHex: String

    public init(id: Int, name: String, species: PetSpecies, breed: String, colorHex: String) {
        self.id = id
        self.name = name
        self.species = species
        self.breed = breed
        self.colorHex = colorHex
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
