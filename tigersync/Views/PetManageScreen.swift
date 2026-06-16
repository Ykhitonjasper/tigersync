import SwiftUI

public struct PetManageScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var species: PetSpecies = .dog
    @State private var breed: String = ""
    @State private var colorHex: String = "#F4A460"

    public let onSave: (String, PetSpecies, String, String) -> Void
    public var editingPet: Pet?

    private let colorOptions = ["#F4A460", "#87CEEB", "#90EE90", "#DDA0DD", "#FFB6C1", "#FFA07A"]

    public init(onSave: @escaping (String, PetSpecies, String, String) -> Void, editingPet: Pet? = nil) {
        self.onSave = onSave
        self.editingPet = editingPet
        if let pet = editingPet {
            _name = State(initialValue: pet.name)
            _species = State(initialValue: pet.species)
            _breed = State(initialValue: pet.breed)
            _colorHex = State(initialValue: pet.colorHex)
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.sectionSpacing) {
                    previewCard

                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Pet info", subtitle: "Basic profile details")
                        VStack(spacing: 14) {
                            TextField("Name", text: $name)
                                .accessibilityIdentifier("pet.nameField")
                            Picker("Species", selection: $species) {
                                ForEach(PetSpecies.allCases, id: \.self) { s in
                                    Label(s.rawValue.capitalized, systemImage: s.icon).tag(s)
                                }
                            }
                            TextField("Breed", text: $breed)
                        }
                        .cardSurface(padding: 14)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Accent color", subtitle: "Used in cards and timeline markers")
                        HStack(spacing: 12) {
                            ForEach(colorOptions, id: \.self) { hex in
                                Button {
                                    colorHex = hex
                                } label: {
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(colorHex == hex ? Color.primary : Color.clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Color \(hex)")
                            }
                        }
                        .cardSurface(padding: 14)
                    }
                }
                .padding(16)
            }
            .screenChrome()
            .navigationTitle(editingPet == nil ? "Add Pet" : "Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        HapticFeedback.success()
                        onSave(name, species, breed, colorHex)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                    .accessibilityIdentifier("pet.save")
                }
            }
        }
        .tint(AppTheme.accent)
    }

    private var previewCard: some View {
        VStack(spacing: 10) {
            Image(systemName: species.icon)
                .font(.title.weight(.semibold))
                .foregroundStyle(Color(hex: colorHex))
                .frame(width: 64, height: 64)
                .background(Color(hex: colorHex).opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text(name.isEmpty ? "New Pet" : name)
                .font(.title3.weight(.bold))
            Text("\(species.rawValue.capitalized) · \(breed.isEmpty ? "Breed" : breed)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: 20)
    }
}

#Preview {
    PetManageScreen { _, _, _, _ in }
}
