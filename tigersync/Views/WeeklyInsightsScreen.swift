import SwiftUI

public struct WeeklyInsightsScreen: View {
    @EnvironmentObject private var appState: AppState
    @State private var report: InsightsEngine.WeeklyReport?
    @State private var pets: [Pet] = []

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                if let report {
                    weekHeader(report)
                    statsGrid(report)
                    insightsList(report.insights)
                    petBreakdown(report)
                } else {
                    EmptyStateView(
                        icon: "chart.bar.doc.horizontal",
                        title: "No weekly data yet",
                        subtitle: "Log behaviour moments to generate your first weekly insights report"
                    )
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Weekly Insights")
        .navigationBarTitleDisplayMode(.large)
        .task(id: appState.dataVersion) {
            await loadReport()
        }
    }

    private func weekHeader(_ report: InsightsEngine.WeeklyReport) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(report.weekLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(report.totalLogs) moments logged")
                .font(.title2.weight(.bold))
            Text("Summary for the past 7 days")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: 16)
    }

    private func statsGrid(_ report: InsightsEngine.WeeklyReport) -> some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Busiest day",
                value: String(report.mostActiveDay.prefix(3)),
                icon: "calendar",
                color: AppTheme.signalTint
            )
            StatCard(
                title: "Patterns",
                value: "\(report.newCorrelations)",
                icon: "chart.line.uptrend.xyaxis",
                color: AppTheme.accentWarm
            )
            StatCard(
                title: "Pets",
                value: "\(report.logsPerPet.count)",
                icon: "pawprint.fill",
                color: AppTheme.accent
            )
        }
    }

    private func insightsList(_ insights: [InsightsEngine.WeeklyInsight]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Insights", subtitle: "Highlights from this week")

            ForEach(insights) { insight in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: insight.icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(trendColor(insight.trend))
                        .frame(width: 32, height: 32)
                        .background(trendColor(insight.trend).opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(insight.title)
                            .font(.subheadline.weight(.semibold))
                        Text(insight.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .cardSurface(padding: 14)
            }
        }
    }

    private func petBreakdown(_ report: InsightsEngine.WeeklyReport) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Per pet", subtitle: "How many moments each pet logged")

            ForEach(pets) { pet in
                let count = report.logsPerPet[pet.id] ?? 0
                HStack(spacing: 12) {
                    Image(systemName: pet.species.icon)
                        .foregroundStyle(Color(hex: pet.colorHex))
                        .frame(width: 28, height: 28)
                        .background(Color(hex: pet.colorHex).opacity(0.14))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Text(pet.name)
                        .font(.subheadline.weight(.semibold))

                    Spacer()

                    Text("\(count) logs")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .cardSurface(padding: 12)
            }
        }
    }

    private func trendColor(_ trend: InsightsEngine.Trend) -> Color {
        switch trend {
        case .up: return AppTheme.confidenceColor(for: 0.85)
        case .down: return AppTheme.accentWarm
        case .stable: return AppTheme.accent
        }
    }

    private func loadReport() async {
        let logs = await appState.storage.loadLogs()
        let correlations = await appState.storage.loadAllCorrelations()
        pets = await appState.storage.loadPets()
        report = InsightsEngine.weeklyReport(logs: logs, correlations: correlations)
    }
}

#Preview {
    NavigationStack {
        WeeklyInsightsScreen()
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
