import Foundation

enum CorrelationEngine {
    static func compute(
        logs: [BehaviourLog],
        minOccurrences: Int = 2
    ) -> [Correlation] {
        guard logs.count >= minOccurrences else { return [] }

        var signalCombinations: [[Int]: (signals: [Int], contexts: [Int])] = [:]

        for log in logs {
            for signalId in log.signalIds {
                let key = [signalId]
                var entry = signalCombinations[key] ?? (signals: [signalId], contexts: [])
                for ctxId in log.contextTagIds {
                    if !entry.contexts.contains(ctxId) {
                        entry.contexts.append(ctxId)
                    }
                }
                signalCombinations[key] = entry
            }
        }

        var results: [Correlation] = []
        var nextId = (logs.map(\.id).max() ?? 0) + 1000

        for (_, entry) in signalCombinations {
            for contextId in entry.contexts {
                let matchingLogs = logs.filter { log in
                    Set(entry.signals).isSubset(of: Set(log.signalIds)) &&
                    log.contextTagIds.contains(contextId)
                }

                let totalWithThisContext = logs.filter { $0.contextTagIds.contains(contextId) }.count

                guard totalWithThisContext >= minOccurrences,
                      matchingLogs.count >= minOccurrences else { continue }

                let confidence = Double(matchingLogs.count) / Double(totalWithThisContext)

                let correlation = Correlation(
                    id: nextId,
                    petId: logs.first?.petId ?? 0,
                    signalIds: entry.signals,
                    contextTagIds: [contextId],
                    matchCount: matchingLogs.count,
                    totalOpportunity: totalWithThisContext,
                    confidence: confidence
                )
                results.append(correlation)
                nextId += 1
            }
        }

        return results
    }

    static func computeForPet(
        petId: Int,
        logs: [BehaviourLog]
    ) -> [Correlation] {
        let petLogs = logs.filter { $0.petId == petId }
        var correlations = compute(logs: petLogs)

        for i in correlations.indices {
            correlations[i] = Correlation(
                id: correlations[i].id,
                petId: petId,
                signalIds: correlations[i].signalIds,
                contextTagIds: correlations[i].contextTagIds,
                matchCount: correlations[i].matchCount,
                totalOpportunity: correlations[i].totalOpportunity,
                confidence: correlations[i].confidence
            )
        }

        return correlations.sorted { $0.confidence > $1.confidence }
    }
}
