import SwiftUI

struct PatternSummaryCard: View {
    let pet: Pet?
    let signals: [Signal]
    let contexts: [ContextTag]
    let correlation: Correlation
    var caption: String = "When these happen together"

    private var confidenceColor: Color {
        AppTheme.confidenceColor(for: correlation.confidence)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(caption)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let pet {
                HStack(spacing: 8) {
                    Image(systemName: pet.species.icon)
                        .foregroundStyle(Color(hex: pet.colorHex))
                    Text(pet.name)
                        .font(.subheadline.weight(.semibold))
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

            Text("\(correlation.matchCount) of \(correlation.totalOpportunity) matching moments")
                .font(.footnote)
                .foregroundStyle(.secondary)

            ConfidenceBar(value: correlation.confidence, color: confidenceColor)

            HStack {
                Text("Confidence")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(correlation.confidencePercent)%")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(confidenceColor)
            }
        }
        .cardSurface(padding: 20)
    }
}

#Preview {
    PatternSummaryCard(
        pet: MockData.pets[0],
        signals: [MockData.signals[0]],
        contexts: [MockData.contextTags[1]],
        correlation: MockData.correlations[0]
    )
    .padding()
}
