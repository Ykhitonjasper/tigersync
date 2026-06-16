import Foundation
import SwiftData

@Model
final class PetRecord {
    @Attribute(.unique) var id: Int
    var name: String
    var speciesRaw: String
    var breed: String
    var colorHex: String

    init(id: Int, name: String, species: PetSpecies, breed: String, colorHex: String) {
        self.id = id
        self.name = name
        self.speciesRaw = species.rawValue
        self.breed = breed
        self.colorHex = colorHex
    }

    var species: PetSpecies {
        get { PetSpecies(rawValue: speciesRaw) ?? .other }
        set { speciesRaw = newValue.rawValue }
    }

    func toPet() -> Pet {
        Pet(id: id, name: name, species: species, breed: breed, colorHex: colorHex)
    }

    func update(from pet: Pet) {
        name = pet.name
        species = pet.species
        breed = pet.breed
        colorHex = pet.colorHex
    }

    static func from(_ pet: Pet) -> PetRecord {
        PetRecord(id: pet.id, name: pet.name, species: pet.species, breed: pet.breed, colorHex: pet.colorHex)
    }
}
