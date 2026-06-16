import SwiftUI

public struct CorrelationCard: View {
    public let correlation: Correlation

    public init(correlation: Correlation) {
        self.correlation = correlation
    }

    private var signals: [Signal] { MockData.signals(for: correlation.signalIds) }
    private var contexts: [ContextTag] { MockData.contextTags(for: correlation.contextTagIds) }

    private var confidenceColor: Color {
        AppTheme.confidenceColor(for: correlation.confidence)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pattern")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(correlationTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(correlation.confidencePercent)%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(confidenceColor)
                    Text("confidence")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            FlowLayout(spacing: 6) {
                ForEach(signals) { signal in
                    InfoChip(icon: signal.icon, name: signal.name, tint: AppTheme.signalTint)
                }
                ForEach(contexts) { tag in
                    InfoChip(icon: tag.icon, name: tag.name, tint: AppTheme.contextTint)
                }
            }

            ConfidenceBar(value: correlation.confidence, color: confidenceColor)
        }
        .cardSurface(padding: 16)
    }

    private var correlationTitle: String {
        let signalNames = signals.map(\.name).joined(separator: ", ")
        let contextNames = contexts.map(\.name).joined(separator: ", ")
        if signalNames.isEmpty || contextNames.isEmpty {
            return "Incomplete pattern"
        }
        return "\(signalNames) → \(contextNames)"
    }
}

#Preview {
    CorrelationCard(correlation: MockData.correlations[0])
        .padding()
}
