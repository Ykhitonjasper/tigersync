import SwiftUI

public struct CorrelationDetailScreen: View {
    public let correlation: Correlation
    public let pet: Pet
    @ObservedObject public var viewModel: BehaviourDictViewModel

    public init(correlation: Correlation, pet: Pet, viewModel: BehaviourDictViewModel) {
        self.correlation = correlation
        self.pet = pet
        self.viewModel = viewModel
    }

    private var signals: [Signal] { viewModel.signals(for: correlation.signalIds) }
    private var contexts: [ContextTag] { viewModel.contexts(for: correlation.contextTagIds) }
    private var matchingLogs: [BehaviourLog] {
        viewModel.matchingLogs(for: correlation)
    }

    public var body: some View {
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
                        subtitle: "Journal entries that support this correlation"
                    )

                    if matchingLogs.isEmpty {
                        EmptyStateView(
                            icon: "doc.text.magnifyingglass",
                            title: "No matching logs",
                            subtitle: "Add more entries with these signals and contexts"
                        )
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(matchingLogs) { log in
                                LogRow(
                                    log: log,
                                    petName: pet.name,
                                    petColor: Color(hex: pet.colorHex)
                                )
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Correlation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CorrelationDetailScreen(
            correlation: MockData.correlations[0],
            pet: MockData.pets[0],
            viewModel: BehaviourDictViewModel(pet: MockData.pets[0], appState: AppState())
        )
        .tint(AppTheme.accent)
    }
}
