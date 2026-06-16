import SwiftUI

public struct TimelineScreen: View {
    @EnvironmentObject private var appState: AppState
    let petId: Int?

    public init(petId: Int? = nil) {
        self.petId = petId
    }

    public var body: some View {
        TimelineContent(appState: appState, petId: petId)
    }
}

private struct TimelineContent: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: TimelineViewModel
    let petId: Int?

    init(appState: AppState, petId: Int?) {
        self.petId = petId
        _viewModel = StateObject(wrappedValue: TimelineViewModel(appState: appState))
    }

    var body: some View {
        ScrollView {
            if viewModel.logs.isEmpty {
                EmptyStateView(
                    icon: "clock",
                    title: "No timeline entries",
                    subtitle: "Behaviour logs will appear here in chronological order"
                )
                .padding(16)
            } else {
                LazyVStack(spacing: AppTheme.sectionSpacing) {
                    ForEach(groupedLogs, id: \.key) { date, logs in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(date)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)

                            LazyVStack(spacing: 10) {
                                ForEach(logs) { log in
                                    timelineRow(log)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .screenChrome()
        .navigationTitle("Timeline")
        .navigationBarTitleDisplayMode(.large)
        .task(id: appState.dataVersion) {
            await viewModel.load(petId: petId)
        }
    }

    private var groupedLogs: [(key: String, value: [BehaviourLog])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"

        let grouped = Dictionary(grouping: viewModel.logs) { log in
            formatter.string(from: log.timestamp)
        }

        return grouped.sorted { a, b in
            let d1 = viewModel.logs.first { formatter.string(from: $0.timestamp) == a.key }?.timestamp ?? Date.distantPast
            let d2 = viewModel.logs.first { formatter.string(from: $0.timestamp) == b.key }?.timestamp ?? Date.distantPast
            return d1 > d2
        }
    }

    private func timelineRow(_ log: BehaviourLog) -> some View {
        let pet = viewModel.pet(for: log.petId)
        return HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(petColor(for: log.petId))
                    .frame(width: 10, height: 10)
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 10)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let pet {
                        Text(pet.name)
                            .font(.caption.weight(.semibold))
                    }
                    Spacer()
                    Text(timeString(log.timestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                FlowLayout(spacing: 6) {
                    ForEach(MockData.signals(for: log.signalIds)) { signal in
                        InfoChip(icon: signal.icon, name: signal.name, tint: AppTheme.signalTint)
                    }
                    ForEach(MockData.contextTags(for: log.contextTagIds)) { tag in
                        InfoChip(icon: tag.icon, name: tag.name, tint: AppTheme.contextTint)
                    }
                }

                if !log.note.isEmpty {
                    Text(log.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .cardSurface(padding: 12)
        }
    }

    private func petColor(for id: Int) -> Color {
        guard let hex = viewModel.pet(for: id)?.colorHex else { return AppTheme.accent }
        return Color(hex: hex)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

@MainActor
final class TimelineViewModel: ObservableObject {
    @Published var logs: [BehaviourLog] = []
    @Published private(set) var pets: [Pet] = []

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func load(petId: Int?) async {
        pets = await appState.storage.loadPets()
        if let petId {
            logs = await appState.storage.loadLogs(for: petId)
        } else {
            logs = await appState.storage.loadLogs().sorted { $0.timestamp > $1.timestamp }
        }
    }

    func pet(for id: Int) -> Pet? {
        pets.first { $0.id == id }
    }
}

#Preview {
    NavigationStack {
        TimelineScreen(petId: 1)
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
