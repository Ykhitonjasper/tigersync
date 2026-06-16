import SwiftUI

public struct DashboardScreen: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: DashboardViewModel
    @State private var isShowingLogEntry = false
    @State private var hapticTrigger = 0

    public init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GlassBg()

            ScrollView {
                VStack(spacing: AppTheme.sectionSpacing) {
                    headerSection

                    if viewModel.isEmpty {
                        emptyStateSection
                    } else {
                        summarySection
                        petCarousel
                        recentLogsSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 88)
            }
            .refreshable {
                await viewModel.load()
            }

            if !viewModel.isEmpty {
                FABButton(action: { isShowingLogEntry = true })
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isShowingLogEntry) {
            LogEntryScreen { signals, contexts, petId, note, timestamp in
                await viewModel.addLog(
                    signals: signals,
                    contexts: contexts,
                    petId: petId,
                    note: note,
                    timestamp: timestamp
                )
            }
        }
        .task(id: appState.dataVersion) {
            await viewModel.load()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("What did you notice today?")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
            if !viewModel.isEmpty {
                NavigationLink(destination: PatternFeedScreen()) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 36, height: 36)
                        .background(AppTheme.accent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .accessibilityLabel("View Patterns")
            }
        }
    }

    // MARK: - Summary

    private var summarySection: some View {
        HStack(spacing: 12) {
            MetricTile(
                value: "\(viewModel.pets.count)",
                label: "Pets",
                icon: "pawprint.fill",
                tint: AppTheme.accent
            )
            MetricTile(
                value: "\(viewModel.totalLogCount)",
                label: "Logs",
                icon: "list.bullet.rectangle",
                tint: AppTheme.signalTint
            )
            MetricTile(
                value: "\(viewModel.patternCount)",
                label: "Patterns",
                icon: "chart.line.uptrend.xyaxis",
                tint: AppTheme.accentWarm
            )
        }
    }

    // MARK: - Empty State

    private var emptyStateSection: some View {
        VStack(spacing: 16) {
            EmptyStateView(
                icon: "pawprint",
                title: "Start your journal",
                subtitle: "Add a pet or load sample data to begin logging behaviour moments"
            )

            NavigationLink(destination: PetManageScreen { name, species, breed, colorHex in
                let petListVM = PetListViewModel(appState: appState)
                Task {
                    await petListVM.addPet(name: name, species: species, breed: breed, colorHex: colorHex)
                    await viewModel.load()
                }
            }) {
                Label("Add Your First Pet", systemImage: "plus.circle.fill")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)

            Button("Load Sample Data") {
                hapticTrigger += 1
                HapticFeedback.success()
                Task { await viewModel.loadSampleData() }
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("dashboard.loadSample")
            .sensoryFeedback(.success, trigger: hapticTrigger)
        }
    }

    // MARK: - Pet Carousel

    private var petCarousel: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Your Pets",
                subtitle: "Tap a pet to open their profile"
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.pets) { pet in
                        NavigationLink(destination: PetProfileScreen(pet: pet)) {
                            PetCard(
                                pet: pet,
                                logCount: viewModel.logCountsByPetId[pet.id] ?? 0
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    // MARK: - Recent Logs

    private var recentLogsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Recent Moments",
                subtitle: "Signals and contexts from your latest entries",
                trailing: viewModel.totalLogCount > 0 ? "\(viewModel.totalLogCount) total" : nil
            )

            if viewModel.recentLogs.isEmpty {
                EmptyStateView(
                    icon: "square.and.pencil",
                    title: "No logs yet",
                    subtitle: "Tap + to record a behaviour moment"
                )
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.recentLogs) { log in
                        if let pet = viewModel.pet(for: log.petId) {
                            NavigationLink(destination: PetProfileScreen(pet: pet)) {
                                LogRow(
                                    log: log,
                                    petName: pet.name,
                                    petColor: Color(hex: pet.colorHex)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                NavigationLink(destination: PatternFeedScreen()) {
                    HStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(AppTheme.accentWarm)
                            .frame(width: 36, height: 36)
                            .background(AppTheme.accentWarm.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("View All Patterns")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(viewModel.patternCount) correlations from your logs")
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
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardScreen(viewModel: DashboardViewModel(appState: AppState()))
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
