import SwiftUI

public struct SignalLibraryScreen: View {
    @State private var selectedCategory: SignalCategory?

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                SectionHeader(
                    title: "Signal Library",
                    subtitle: "16 behaviour signals with species-specific notes",
                    trailing: "\(filteredEntries.count) signals"
                )

                categoryFilter

                ForEach(filteredEntries) { entry in
                    signalCard(entry)
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Signal Library")
        .navigationBarTitleDisplayMode(.large)
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                ForEach(SignalCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.displayName,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
        }
    }

    private var filteredEntries: [SignalLibraryData.Entry] {
        guard let selectedCategory else { return SignalLibraryData.entries }
        return SignalLibraryData.entries(in: selectedCategory)
    }

    private func signalCard(_ entry: SignalLibraryData.Entry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: entry.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppTheme.signalTint)
                    .frame(width: 36, height: 36)
                    .background(AppTheme.signalTint.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.name)
                        .font(.headline)
                    Text(entry.category.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Text(entry.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label(entry.watchFor, systemImage: "eye")
                .font(.caption)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Species notes")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                ForEach(PetSpecies.allCases.filter { $0 != .other }, id: \.self) { species in
                    if let note = entry.speciesNotes[species] {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: species.icon)
                                .font(.caption)
                                .foregroundStyle(AppTheme.accent)
                                .frame(width: 16)
                            Text(note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
        }
        .cardSurface(padding: 14)
    }
}

#Preview {
    NavigationStack {
        SignalLibraryScreen()
            .tint(AppTheme.accent)
    }
}
