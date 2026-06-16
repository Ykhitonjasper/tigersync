import SwiftUI

public struct LearnHubScreen: View {
    @State private var selectedSpecies: PetSpecies = .dog

    public init() {}

    public var body: some View {
        ZStack {
            GlassBg()

            ScrollView {
                VStack(spacing: AppTheme.sectionSpacing) {
                    speciesSection
                    toolsSection
                    guidesSection
                    referenceSection
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.large)
    }

    private var speciesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Species focus",
                subtitle: "Guides and patterns tailored to one species"
            )

            Picker("Species", selection: $selectedSpecies) {
                ForEach(PetSpecies.allCases.filter { $0 != .other }, id: \.self) { species in
                    Label(species.rawValue.capitalized, systemImage: species.icon).tag(species)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Insights", subtitle: "Analyze your journal data")

            NavigationLink(destination: WeeklyInsightsScreen()) {
                hubCard(
                    icon: "chart.bar.doc.horizontal",
                    title: "Weekly Insights",
                    subtitle: "Logs, trends, and pattern summary"
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: StressScoreScreen()) {
                hubCard(
                    icon: "heart.text.clipboard",
                    title: "Stress Score",
                    subtitle: "7-day stress signal calculator"
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var guidesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Behaviour Guides",
                trailing: "\(BehaviourGuidesData.guides(for: selectedSpecies).count) articles"
            )

            ForEach(BehaviourGuidesData.guides(for: selectedSpecies)) { guide in
                NavigationLink(destination: BehaviourGuideDetailScreen(guide: guide)) {
                    hubCard(
                        icon: guide.icon,
                        title: guide.title,
                        subtitle: "\(guide.readMinutes) min read — \(guide.subtitle)"
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var referenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Reference Libraries", subtitle: "Deep dives into signals and contexts")

            NavigationLink(destination: SpeciesReferenceScreen()) {
                hubCard(
                    icon: "leaf.arrow.triangle.circlepath",
                    title: "Species Patterns",
                    subtitle: "\(SpeciesReferenceData.patternCount(for: selectedSpecies)) patterns for \(selectedSpecies.rawValue)"
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: SignalLibraryScreen()) {
                hubCard(
                    icon: "waveform.path",
                    title: "Signal Library",
                    subtitle: "16 signals with species notes"
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: ContextGuideListScreen()) {
                hubCard(
                    icon: "mappin.and.ellipse",
                    title: "Context Guides",
                    subtitle: "10 situations with logging tips"
                )
            }
            .buttonStyle(.plain)
        }
    }

    private func hubCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 36, height: 36)
                .background(AppTheme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
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
        LearnHubScreen()
            .tint(AppTheme.accent)
    }
}
