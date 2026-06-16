import SwiftUI

struct MetricTile: View {
    let value: String
    let label: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(tint.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: 14)
    }
}

#Preview {
    HStack(spacing: 12) {
        MetricTile(value: "4", label: "Pets", icon: "pawprint.fill", tint: AppTheme.accent)
        MetricTile(value: "28", label: "Logs", icon: "list.bullet", tint: AppTheme.signalTint)
        MetricTile(value: "6", label: "Patterns", icon: "chart.line.uptrend.xyaxis", tint: AppTheme.accentWarm)
    }
    .padding()
}
