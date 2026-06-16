import SwiftUI

public struct StressScoreScreen: View {
    @EnvironmentObject private var appState: AppState
    @State private var pets: [Pet] = []
    @State private var selectedPetId: Int?
    @State private var days = 7
    @State private var output: StressScoreCalculator.Output?

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                if pets.isEmpty {
                    EmptyStateView(
                        icon: "heart.text.clipboard",
                        title: "No pets yet",
                        subtitle: "Add a pet and log moments to calculate a stress score"
                    )
                } else {
                    controls
                    if let output {
                        scoreCard(output)
                        triggersSection(output)
                        recommendationCard(output.recommendation)
                    }
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Stress Score")
        .navigationBarTitleDisplayMode(.large)
        .task(id: appState.dataVersion) {
            await reload()
        }
        .onChange(of: selectedPetId) { _, _ in recalculate() }
        .onChange(of: days) { _, _ in recalculate() }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Parameters", subtitle: "Choose pet and analysis period")

            VStack(spacing: 12) {
                Picker("Pet", selection: Binding(
                    get: { selectedPetId ?? pets.first?.id ?? 0 },
                    set: { selectedPetId = $0 }
                )) {
                    ForEach(pets) { pet in
                        Label(pet.name, systemImage: pet.species.icon).tag(pet.id)
                    }
                }
                .pickerStyle(.menu)

                Picker("Period", selection: $days) {
                    Text("7 days").tag(7)
                    Text("14 days").tag(14)
                    Text("30 days").tag(30)
                }
                .pickerStyle(.segmented)
            }
            .cardSurface(padding: 14)
        }
    }

    private func scoreCard(_ output: StressScoreCalculator.Output) -> some View {
        VStack(spacing: 10) {
            Text("\(output.score)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(scoreColor(output.level))

            Text(output.level.rawValue)
                .font(.title3.weight(.semibold))

            Text("\(output.stressLogCount) of \(output.totalLogs) logs show stress signals")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: 24)
    }

    private func triggersSection(_ output: StressScoreCalculator.Output) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Top triggers", subtitle: "Contexts most linked to stress signals")

            if output.topTriggers.isEmpty {
                Text("No stress triggers identified in this period.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .cardSurface(padding: 14)
            } else {
                ForEach(output.topTriggers) { trigger in
                    if let guide = ContextGuidesData.guide(for: trigger.contextId) {
                        HStack(spacing: 12) {
                            Image(systemName: guide.icon)
                                .foregroundStyle(AppTheme.contextTint)
                                .frame(width: 28, height: 28)
                                .background(AppTheme.contextTint.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                            Text(guide.name)
                                .font(.subheadline.weight(.semibold))

                            Spacer()

                            Text("\(trigger.count)×")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        .cardSurface(padding: 12)
                    }
                }
            }
        }
    }

    private func recommendationCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Recommendation", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.accentWarm)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardSurface(padding: 16)
    }

    private func scoreColor(_ level: StressScoreCalculator.StressLevel) -> Color {
        switch level {
        case .low: return AppTheme.confidenceColor(for: 0.85)
        case .moderate: return AppTheme.accentWarm
        case .elevated: return AppTheme.accentWarm
        case .high: return AppTheme.accent
        }
    }

    private func reload() async {
        pets = await appState.storage.loadPets()
        if selectedPetId == nil {
            selectedPetId = pets.first?.id
        }
        recalculate(with: await appState.storage.loadLogs())
    }

    private func recalculate() {
        Task {
            let logs = await appState.storage.loadLogs()
            recalculate(with: logs)
        }
    }

    private func recalculate(with logs: [BehaviourLog]) {
        guard let petId = selectedPetId ?? pets.first?.id else {
            output = nil
            return
        }
        let petLogs = logs.filter { $0.petId == petId }
        output = StressScoreCalculator.compute(
            StressScoreCalculator.Input(
                logs: petLogs,
                days: days,
                stressSignalIds: StressScoreCalculator.defaultStressSignals,
                highIntensityContextIds: StressScoreCalculator.defaultHighIntensityContexts
            )
        )
    }
}

#Preview {
    NavigationStack {
        StressScoreScreen()
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
