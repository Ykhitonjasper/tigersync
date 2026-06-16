import Foundation

enum SpeciesReferenceData {
    struct Pattern: Identifiable {
        let id: Int
        let signal: String
        let context: String
        let meaning: String
        let confidence: String
        let category: String
        let actionTip: String
    }

    static let dogPatterns: [Pattern] = DogPatternsData.patterns
    static let catPatterns: [Pattern] = CatPatternsData.patterns
    static let birdPatterns: [Pattern] = BirdPatternsData.patterns
    static let rabbitPatterns: [Pattern] = RabbitPatternsData.patterns

    static func patterns(for species: PetSpecies) -> [Pattern] {
        switch species {
        case .dog: return dogPatterns
        case .cat: return catPatterns
        case .bird: return birdPatterns
        case .rabbit: return rabbitPatterns
        case .other: return dogPatterns + catPatterns + birdPatterns + rabbitPatterns
        }
    }

    static func patternCount(for species: PetSpecies) -> Int {
        patterns(for: species).count
    }

    static var allPatterns: [Pattern] {
        dogPatterns + catPatterns + birdPatterns + rabbitPatterns
    }

    static func patterns(in category: String, species: PetSpecies) -> [Pattern] {
        patterns(for: species).filter { $0.category == category }
    }

    static func categories(for species: PetSpecies) -> [String] {
        Array(Set(patterns(for: species).map(\.category))).sorted()
    }

    static func search(_ query: String, species: PetSpecies) -> [Pattern] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return patterns(for: species) }
        return patterns(for: species).filter {
            $0.signal.lowercased().contains(trimmed) ||
            $0.context.lowercased().contains(trimmed) ||
            $0.meaning.lowercased().contains(trimmed) ||
            $0.category.lowercased().contains(trimmed)
        }
    }
}
