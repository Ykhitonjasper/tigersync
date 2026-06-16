import SwiftUI

@MainActor
final public class PetListViewModel: ObservableObject {
    @Published public var pets: [Pet] = []
    @Published public var isShowingAddPet = false

    private let appState: AppState

    public init(appState: AppState) {
        self.appState = appState
    }

    public func load() async {
        pets = await appState.storage.loadPets()
    }

    public func addPet(name: String, species: PetSpecies, breed: String, colorHex: String) async {
        let id = await appState.storage.nextPetId()
        let pet = Pet(id: id, name: name, species: species, breed: breed, colorHex: colorHex)
        await appState.storage.savePet(pet)
        appState.notifyDataChanged()
        await load()
    }

    public func updatePet(_ pet: Pet) async {
        await appState.storage.savePet(pet)
        appState.notifyDataChanged()
        await load()
    }

    public func deletePet(id: Int) async {
        await appState.storage.deletePet(id: id)
        appState.notifyDataChanged()
        await load()
    }
}
