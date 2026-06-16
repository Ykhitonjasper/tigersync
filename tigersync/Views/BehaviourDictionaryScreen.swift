import SwiftUI

public struct BehaviourDictionaryScreen: View {
    @EnvironmentObject private var appState: AppState
    public let pet: Pet

    public init(pet: Pet) {
        self.pet = pet
    }

    public var body: some View {
        BehaviourDictionaryContent(appState: appState, pet: pet)
    }
}

private struct BehaviourDictionaryContent: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: BehaviourDictViewModel

    init(appState: AppState, pet: Pet) {
        _viewModel = StateObject(wrappedValue: BehaviourDictViewModel(pet: pet, appState: appState))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                SectionHeader(
                    title: "\(viewModel.pet.name)'s Dictionary",
                    subtitle: "Personal correlations from logged behaviour",
                    trailing: viewModel.correlations.isEmpty ? nil : "\(viewModel.correlations.count) patterns"
                )

                if viewModel.correlations.isEmpty {
                    EmptyStateView(
                        icon: "book.closed",
                        title: "No correlations yet",
                        subtitle: "Log more behaviour moments to discover patterns in \(viewModel.pet.name)'s behaviour"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.correlations) { correlation in
                            NavigationLink(destination: CorrelationDetailScreen(
                                correlation: correlation,
                                pet: viewModel.pet,
                                viewModel: viewModel
                            )) {
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
        .navigationTitle("Dictionary")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: appState.dataVersion) {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        BehaviourDictionaryScreen(pet: MockData.pets[0])
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
