import Foundation

enum StressScoreCalculator {
    struct Input: Sendable {
        let logs: [BehaviourLog]
        let days: Int
        let stressSignalIds: Set<Int>
        let highIntensityContextIds: Set<Int>
    }

    struct Output: Sendable {
        let score: Int
        let level: StressLevel
        let stressLogCount: Int
        let totalLogs: Int
        let topTriggers: [TriggerSummary]
        let recommendation: String
    }

    enum StressLevel: String, Sendable {
        case low = "Low"
        case moderate = "Moderate"
        case elevated = "Elevated"
        case high = "High"

        var colorName: String {
            switch self {
            case .low: return "green"
            case .moderate: return "yellow"
            case .elevated: return "orange"
            case .high: return "red"
            }
        }
    }

    struct TriggerSummary: Identifiable, Sendable {
        let id: Int
        let contextId: Int
        let count: Int
    }

    static let defaultStressSignals: Set<Int> = [2, 6, 11, 13]
    static let defaultHighIntensityContexts: Set<Int> = [6, 7, 2]

    static func compute(_ input: Input) -> Output {
        let cutoff = Calendar.current.date(byAdding: .day, value: -input.days, to: Date()) ?? .distantPast
        let recent = input.logs.filter { $0.timestamp >= cutoff }
        guard !recent.isEmpty else {
            return Output(
                score: 0,
                level: .low,
                stressLogCount: 0,
                totalLogs: 0,
                topTriggers: [],
                recommendation: "Log more moments this week to calculate a stress score."
            )
        }

        let stressLogs = recent.filter { log in
            !Set(log.signalIds).isDisjoint(with: input.stressSignalIds) ||
            !Set(log.contextTagIds).isDisjoint(with: input.highIntensityContextIds)
        }

        let ratio = Double(stressLogs.count) / Double(recent.count)
        let score = min(100, Int(ratio * 100))

        let level: StressLevel
        switch score {
        case 0...20: level = .low
        case 21...45: level = .moderate
        case 46...70: level = .elevated
        default: level = .high
        }

        var contextCounts: [Int: Int] = [:]
        for log in stressLogs {
            for ctx in log.contextTagIds {
                contextCounts[ctx, default: 0] += 1
            }
        }

        let topTriggers = contextCounts
            .sorted { $0.value > $1.value }
            .prefix(3)
            .enumerated()
            .map { TriggerSummary(id: $0.offset, contextId: $0.element.key, count: $0.element.value) }

        let recommendation = recommendation(for: level, triggers: topTriggers)

        return Output(
            score: score,
            level: level,
            stressLogCount: stressLogs.count,
            totalLogs: recent.count,
            topTriggers: topTriggers,
            recommendation: recommendation
        )
    }

    private static func recommendation(for level: StressLevel, triggers: [TriggerSummary]) -> String {
        switch level {
        case .low:
            return "Stress signals are infrequent. Keep logging to maintain your behaviour dictionary."
        case .moderate:
            return "Some stress patterns emerging. Review species reference for your top contexts."
        case .elevated:
            if let first = triggers.first,
               let guide = ContextGuidesData.guide(for: first.contextId) {
                return "Elevated stress around \(guide.name). Try: \(guide.reduceStress.first ?? "add recovery time")"
            }
            return "Elevated stress detected. Add quiet recovery time after intense contexts."
        case .high:
            return "High stress frequency — consider sharing your exported log with a trainer or vet."
        }
    }
}
