import Foundation

enum InsightsEngine {
    struct WeeklyInsight: Identifiable, Sendable {
        let id: Int
        let title: String
        let detail: String
        let icon: String
        let trend: Trend
    }

    enum Trend: String, Sendable {
        case up, down, stable
    }

    struct WeeklyReport: Sendable {
        let weekLabel: String
        let totalLogs: Int
        let logsPerPet: [Int: Int]
        let mostActiveDay: String
        let topSignalId: Int?
        let topContextId: Int?
        let newCorrelations: Int
        let insights: [WeeklyInsight]
    }

    static func weeklyReport(
        logs: [BehaviourLog],
        correlations: [Correlation],
        calendar: Calendar = .current
    ) -> WeeklyReport {
        let now = Date()
        let weekStart = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        let weekLogs = logs.filter { $0.timestamp >= weekStart }

        var logsPerPet: [Int: Int] = [:]
        for log in weekLogs {
            logsPerPet[log.petId, default: 0] += 1
        }

        var dayCounts: [String: Int] = [:]
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        for log in weekLogs {
            let day = dayFormatter.string(from: log.timestamp)
            dayCounts[day, default: 0] += 1
        }
        let mostActiveDay = dayCounts.max(by: { $0.value < $1.value })?.key ?? "—"

        var signalCounts: [Int: Int] = [:]
        for log in weekLogs {
            for signalId in log.signalIds {
                signalCounts[signalId, default: 0] += 1
            }
        }
        let topSignalId = signalCounts.max(by: { $0.value < $1.value })?.key

        var contextCounts: [Int: Int] = [:]
        for log in weekLogs {
            for ctx in log.contextTagIds {
                contextCounts[ctx, default: 0] += 1
            }
        }
        let topContextId = contextCounts.max(by: { $0.value < $1.value })?.key

        let priorWeekStart = calendar.date(byAdding: .day, value: -14, to: now) ?? now
        let priorWeekLogs = logs.filter { $0.timestamp >= priorWeekStart && $0.timestamp < weekStart }
        let trendUp = weekLogs.count > priorWeekLogs.count

        var insights: [WeeklyInsight] = []
        var nextId = 1

        if weekLogs.isEmpty {
            insights.append(WeeklyInsight(
                id: nextId,
                title: "Start your week",
                detail: "No logs yet this week. Tap + on the Journal tab to capture a moment.",
                icon: "plus.circle",
                trend: .stable
            ))
            nextId += 1
        } else {
            insights.append(WeeklyInsight(
                id: nextId,
                title: "Logging streak",
                detail: "You recorded \(weekLogs.count) moments — \(trendUp ? "up" : "down") from last week.",
                icon: "calendar",
                trend: trendUp ? .up : .down
            ))
            nextId += 1
        }

        if let topSignalId,
           let signal = MockData.signals.first(where: { $0.id == topSignalId }) {
            insights.append(WeeklyInsight(
                id: nextId,
                title: "Top signal: \(signal.name)",
                detail: "\(signal.name) appeared most often. Check Signal Library for interpretation tips.",
                icon: "star.fill",
                trend: .stable
            ))
            nextId += 1
        }

        if let topContextId,
           let guide = ContextGuidesData.guide(for: topContextId) {
            insights.append(WeeklyInsight(
                id: nextId,
                title: "Busiest context: \(guide.name)",
                detail: guide.overview,
                icon: "tag.fill",
                trend: .stable
            ))
            nextId += 1
        }

        let strongCorrelations = correlations.filter { $0.confidence >= 0.7 }
        insights.append(WeeklyInsight(
            id: nextId,
            title: "Strong patterns",
            detail: "\(strongCorrelations.count) correlations above 70% confidence in your dictionary.",
            icon: "sparkles",
            trend: strongCorrelations.isEmpty ? .down : .up
        ))

        let weekLabel = weekStart.formatted(.dateTime.month(.abbreviated).day()) + " – " + now.formatted(.dateTime.month(.abbreviated).day())

        return WeeklyReport(
            weekLabel: weekLabel,
            totalLogs: weekLogs.count,
            logsPerPet: logsPerPet,
            mostActiveDay: mostActiveDay,
            topSignalId: topSignalId,
            topContextId: topContextId,
            newCorrelations: strongCorrelations.count,
            insights: insights
        )
    }
}
