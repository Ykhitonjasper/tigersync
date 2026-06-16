import Foundation

enum ExportFormatter {
    static func textExport(
        logs: [BehaviourLog],
        pets: [Pet],
        correlations: [Correlation]
    ) -> String {
        var lines: [String] = []
        lines.append("tigersync Behaviour Export")
        lines.append("Generated: \(Date().formatted(date: .abbreviated, time: .shortened))")
        lines.append("Total logs: \(logs.count)")
        lines.append(String(repeating: "—", count: 40))
        lines.append("")

        let sorted = logs.sorted { $0.timestamp > $1.timestamp }
        for log in sorted {
            let petName = pets.first(where: { $0.id == log.petId })?.name ?? "Unknown"
            let signals = MockData.signals(for: log.signalIds).map(\.name).joined(separator: ", ")
            let contexts = MockData.contextTags(for: log.contextTagIds).map(\.name).joined(separator: ", ")
            lines.append("[\(log.timestamp.formatted(date: .abbreviated, time: .shortened))] \(petName)")
            lines.append("  Signals: \(signals)")
            lines.append("  Context: \(contexts)")
            if !log.note.isEmpty {
                lines.append("  Note: \(log.note)")
            }
            lines.append("")
        }

        lines.append(String(repeating: "—", count: 40))
        lines.append("Correlations summary")
        for pet in pets {
            let petCorrelations = correlations.filter { $0.petId == pet.id }
            guard !petCorrelations.isEmpty else { continue }
            lines.append("\(pet.name):")
            for corr in petCorrelations {
                let sigs = MockData.signals(for: corr.signalIds).map(\.name).joined(separator: " + ")
                let ctx = MockData.contextTags(for: corr.contextTagIds).map(\.name).joined(separator: ", ")
                let pct = Int(corr.confidence * 100)
                lines.append("  • \(sigs) during \(ctx) — \(pct)% (\(corr.matchCount)/\(corr.totalOpportunity))")
            }
        }

        return lines.joined(separator: "\n")
    }

    static func csvExport(logs: [BehaviourLog], pets: [Pet]) -> String {
        var rows = ["timestamp,pet,signals,contexts,note"]
        let sorted = logs.sorted { $0.timestamp > $1.timestamp }
        for log in sorted {
            let petName = pets.first(where: { $0.id == log.petId })?.name ?? "Unknown"
            let signals = MockData.signals(for: log.signalIds).map(\.name).joined(separator: "; ")
            let contexts = MockData.contextTags(for: log.contextTagIds).map(\.name).joined(separator: "; ")
            let note = log.note.replacingOccurrences(of: "\"", with: "\"\"")
            rows.append("\"\(log.timestamp.ISO8601Format())\",\"\(petName)\",\"\(signals)\",\"\(contexts)\",\"\(note)\"")
        }
        return rows.joined(separator: "\n")
    }
}
