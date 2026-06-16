import SwiftUI

public struct PatternFeedScreen: View {
    @EnvironmentObject private var appState: AppState

    public init() {}

    public var body: some View {
        PatternFeedContent(appState: appState)
    }
}

private struct PatternFeedContent: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: PatternFeedViewModel

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: PatternFeedViewModel(appState: appState))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                SectionHeader(
                    title: "Patterns",
                    subtitle: "Correlations discovered from your behaviour logs",
                    trailing: viewModel.filteredCorrelations.isEmpty ? nil : "\(viewModel.filteredCorrelations.count) found"
                )

                filterBar

                if viewModel.filteredCorrelations.isEmpty {
                    EmptyStateView(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "No patterns found",
                        subtitle: "Log more moments or lower the confidence filter to discover behaviour patterns"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredCorrelations) { correlation in
                            NavigationLink(destination: patternDetail(correlation)) {
                                CorrelationCard(correlation: correlation)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Patterns")
        .navigationBarTitleDisplayMode(.large)
        .task(id: appState.dataVersion) {
            await viewModel.load()
        }
    }

    private func patternDetail(_ correlation: Correlation) -> some View {
        PatternDetailScreen(correlation: correlation, appState: appState)
    }

    private var filterBar: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All Pets",
                        isSelected: viewModel.selectedPetId == nil,
                        action: { viewModel.selectedPetId = nil }
                    )
                    ForEach(viewModel.pets) { pet in
                        FilterChip(
                            title: pet.name,
                            isSelected: viewModel.selectedPetId == pet.id,
                            action: { viewModel.selectedPetId = pet.id }
                        )
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All Confidence",
                        isSelected: viewModel.minConfidence == 0,
                        action: { viewModel.minConfidence = 0 }
                    )
                    FilterChip(
                        title: "High (80%+)",
                        isSelected: viewModel.minConfidence == 0.8,
                        action: { viewModel.minConfidence = 0.8 }
                    )
                    FilterChip(
                        title: "Medium (50%+)",
                        isSelected: viewModel.minConfidence == 0.5,
                        action: { viewModel.minConfidence = 0.5 }
                    )
                }
            }
        }
        .cardSurface(padding: 14)
    }
}

// MARK: - Pattern Detail

private struct PatternDetailScreen: View {
    let correlation: Correlation
    let appState: AppState
    @State private var pet: Pet?
    @State private var matchingLogs: [BehaviourLog] = []

    private var signals: [Signal] { MockData.signals(for: correlation.signalIds) }
    private var contexts: [ContextTag] { MockData.contextTags(for: correlation.contextTagIds) }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                PatternSummaryCard(
                    pet: pet,
                    signals: signals,
                    contexts: contexts,
                    correlation: correlation
                )

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(
                        title: "Matching Moments",
                        subtitle: "Logs that contain this signal + context combination"
                    )

                    if matchingLogs.isEmpty {
                        EmptyStateView(
                            icon: "doc.text.magnifyingglass",
                            title: "No matching logs",
                            subtitle: "This pattern may come from partial overlaps in your journal"
                        )
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(matchingLogs) { log in
                                LogRow(
                                    log: log,
                                    petName: pet?.name ?? "",
                                    petColor: Color(hex: pet?.colorHex ?? "#888888")
                                )
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Pattern Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            pet = await appState.storage.pet(for: correlation.petId)
            let logs = await appState.storage.loadLogs(for: correlation.petId)
            matchingLogs = logs.filter { log in
                Set(log.signalIds).isSuperset(of: Set(correlation.signalIds)) &&
                Set(log.contextTagIds).isSuperset(of: Set(correlation.contextTagIds))
            }
        }
    }
}

// MARK: - ViewModel

@MainActor
final class PatternFeedViewModel: ObservableObject {
    @Published var correlations: [Correlation] = []
    @Published var pets: [Pet] = []
    @Published var selectedPetId: Int? = nil
    @Published var minConfidence: Double = 0

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    var filteredCorrelations: [Correlation] {
        correlations.filter { c in
            if let petId = selectedPetId, c.petId != petId { return false }
            if c.confidence < minConfidence { return false }
            return true
        }
    }

    func pet(for id: Int) -> Pet? {
        pets.first { $0.id == id }
    }

    func load() async {
        pets = await appState.storage.loadPets()
        correlations = await appState.storage.loadAllCorrelations()
    }
}

#Preview {
    NavigationStack {
        PatternFeedScreen()
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
