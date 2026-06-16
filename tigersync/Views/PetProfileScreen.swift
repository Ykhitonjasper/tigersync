import SwiftUI

public struct PetProfileScreen: View {
    @EnvironmentObject private var appState: AppState
    public let pet: Pet

    public init(pet: Pet) {
        self.pet = pet
    }

    public var body: some View {
        PetProfileContent(appState: appState, pet: pet)
    }
}

private struct PetProfileContent: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: PetProfileViewModel
    @State private var isShowingEditPet = false

    private var petColor: Color { Color(hex: viewModel.pet.colorHex) }

    init(appState: AppState, pet: Pet) {
        _viewModel = StateObject(wrappedValue: PetProfileViewModel(pet: pet, appState: appState))
    }

    var body: some View {
        ZStack {
            GlassBg()

            ScrollView {
                VStack(spacing: AppTheme.sectionSpacing) {
                    heroSection
                    quickStats
                    recentLogsSection
                    actionsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(viewModel.pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit", systemImage: "pencil") {
                    isShowingEditPet = true
                }
                .accessibilityLabel("Edit pet")
            }
        }
        .sheet(isPresented: $isShowingEditPet) {
            PetManageScreen(onSave: { name, species, breed, colorHex in
                Task {
                    var updated = viewModel.pet
                    updated.name = name
                    updated.species = species
                    updated.breed = breed
                    updated.colorHex = colorHex
                    await appState.storage.savePet(updated)
                    appState.notifyDataChanged()
                    await viewModel.load()
                }
            }, editingPet: viewModel.pet)
        }
        .task(id: appState.dataVersion) {
            await viewModel.load()
        }
    }

    private var heroSection: some View {
        VStack(spacing: 14) {
            Image(systemName: viewModel.pet.species.icon)
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(petColor)
                .frame(width: 80, height: 80)
                .background(petColor.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            VStack(spacing: 6) {
                Text(viewModel.pet.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(viewModel.pet.species.rawValue.capitalized) · \(viewModel.pet.breed)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: 24)
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            StatCard(title: "Logs", value: "\(viewModel.logs.count)", icon: "list.bullet", color: AppTheme.signalTint)
            StatCard(title: "Top Signal", value: viewModel.topSignal?.name ?? "—", icon: "star.fill", color: AppTheme.accentWarm)
            StatCard(title: "Top Context", value: viewModel.topContext?.name ?? "—", icon: "tag.fill", color: AppTheme.contextTint)
        }
    }

    private var recentLogsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recent Moments")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Latest behaviour entries for \(viewModel.pet.name)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if viewModel.logs.count > 0 {
                    Text("\(viewModel.logs.count) total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                NavigationLink(destination: TimelineScreen(petId: viewModel.pet.id)) {
                    Text("Timeline")
                        .font(.caption.weight(.semibold))
                }
            }

            if viewModel.logs.isEmpty {
                EmptyStateView(
                    icon: "square.and.pencil",
                    title: "No logs yet",
                    subtitle: "Record the first behaviour moment for \(viewModel.pet.name)"
                )
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.logs.prefix(5)) { log in
                        LogRow(
                            log: log,
                            petName: viewModel.pet.name,
                            petColor: petColor
                        )
                        .contextMenu {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                Task { await viewModel.deleteLog(id: log.id) }
                            }
                        }
                    }
                }
            }
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Explore", subtitle: "Deeper views for this pet")

            NavigationLink(destination: BehaviourDictionaryScreen(pet: viewModel.pet)) {
                actionCard(icon: "book.closed", title: "Behaviour Dictionary", subtitle: "Correlations built from \(viewModel.pet.name)'s logs")
            }
            .buttonStyle(.plain)

            NavigationLink(destination: SpeciesReferenceScreen(pet: viewModel.pet)) {
                actionCard(icon: "leaf.arrow.triangle.circlepath", title: "Species Reference", subtitle: "Common \(viewModel.pet.species.rawValue) behaviour patterns")
            }
            .buttonStyle(.plain)
        }
    }

    private func actionCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(petColor)
                .frame(width: 36, height: 36)
                .background(petColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .cardSurface(padding: 14)
    }
}

#Preview {
    NavigationStack {
        PetProfileScreen(pet: MockData.pets[0])
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
