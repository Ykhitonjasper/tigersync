import SwiftUI

public struct PetListScreen: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: PetListViewModel
    @State private var editingPet: Pet?

    public init(viewModel: PetListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            GlassBg()

            Group {
                if viewModel.pets.isEmpty {
                    emptyState
                } else {
                    petList
                }
            }
        }
        .navigationTitle("Pets")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Pet", systemImage: "plus") {
                    viewModel.isShowingAddPet = true
                }
                .accessibilityIdentifier("pets.add")
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddPet) {
            PetManageScreen { name, species, breed, colorHex in
                Task {
                    await viewModel.addPet(name: name, species: species, breed: breed, colorHex: colorHex)
                }
            }
        }
        .sheet(item: $editingPet) { pet in
            PetManageScreen(onSave: { name, species, breed, colorHex in
                Task {
                    var updated = pet
                    updated.name = name
                    updated.species = species
                    updated.breed = breed
                    updated.colorHex = colorHex
                    await viewModel.updatePet(updated)
                }
            }, editingPet: pet)
        }
        .task(id: appState.dataVersion) {
            await viewModel.load()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            EmptyStateView(
                icon: "pawprint",
                title: "No pets yet",
                subtitle: "Add your first pet to start logging behaviour"
            )
            Button("Add Pet", systemImage: "plus.circle.fill") {
                viewModel.isShowingAddPet = true
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
        }
        .padding()
    }

    private var petList: some View {
        List {
            Section {
                ForEach(viewModel.pets) { pet in
                    NavigationLink(destination: PetProfileScreen(pet: pet)) {
                        HStack(spacing: 14) {
                            Image(systemName: pet.species.icon)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Color(hex: pet.colorHex))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: pet.colorHex).opacity(0.14))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(pet.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text("\(pet.species.rawValue.capitalized) · \(pet.breed)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            Task { await viewModel.deletePet(id: pet.id) }
                        }
                        Button("Edit", systemImage: "pencil") {
                            editingPet = pet
                        }
                    }
                }
            } header: {
                Text("\(viewModel.pets.count) pets in your journal")
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        PetListScreen(viewModel: PetListViewModel(appState: AppState()))
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
