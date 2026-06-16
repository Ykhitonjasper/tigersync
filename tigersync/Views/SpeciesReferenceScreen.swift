import SwiftUI

public struct SpeciesReferenceScreen: View {
    let pet: Pet?
    @State private var selectedSpecies: PetSpecies
    @State private var searchText = ""
    @State private var selectedCategory: String?

    public init(pet: Pet? = nil) {
        self.pet = pet
        _selectedSpecies = State(initialValue: pet?.species ?? .dog)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                speciesPicker
                SearchField(placeholder: "Search patterns", text: $searchText)
                categoryFilter
                patternsList
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Species Reference")
        .navigationBarTitleDisplayMode(.large)
    }

    private var speciesPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Species", subtitle: "Filter reference patterns by animal type")
            Picker("Species", selection: $selectedSpecies) {
                ForEach(PetSpecies.allCases.filter { $0 != .other }, id: \.self) { species in
                    Label(species.rawValue.capitalized, systemImage: species.icon).tag(species)
                }
            }
            .pickerStyle(.segmented)
        }
        .onChange(of: selectedSpecies) { _, _ in
            selectedCategory = nil
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                ForEach(SpeciesReferenceData.categories(for: selectedSpecies), id: \.self) { category in
                    FilterChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
        }
    }

    private var filteredPatterns: [SpeciesReferenceData.Pattern] {
        var patterns = SpeciesReferenceData.search(searchText, species: selectedSpecies)
        if let selectedCategory {
            patterns = patterns.filter { $0.category == selectedCategory }
        }
        return patterns
    }

    private var patternsList: some View {
        LazyVStack(spacing: 12) {
            SectionHeader(
                title: "Patterns",
                trailing: "\(filteredPatterns.count) results"
            )

            ForEach(filteredPatterns) { pattern in
                PatternReferenceRow(pattern: pattern)
            }
        }
    }
}

// MARK: - Pattern Reference Row

private struct PatternReferenceRow: View {
    let pattern: SpeciesReferenceData.Pattern

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.signal)
                        .font(.headline)
                    Text(pattern.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(pattern.confidence)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundStyle(confidenceColor)
                    .background(confidenceColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Label(pattern.context, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(pattern.meaning)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.accentWarm)
                    .padding(.top, 2)
                Text(pattern.actionTip)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.accentWarm.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
        }
        .cardSurface(padding: 14)
    }

    private var confidenceColor: Color {
        switch pattern.confidence {
        case "Very common": return AppTheme.confidenceColor(for: 0.85)
        case "Common": return AppTheme.accentWarm
        default: return .secondary
        }
    }
}

#Preview {
    NavigationStack {
        SpeciesReferenceScreen(pet: MockData.pets[0])
            .tint(AppTheme.accent)
    }
}
