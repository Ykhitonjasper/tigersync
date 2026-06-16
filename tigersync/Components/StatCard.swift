import SwiftUI

public struct StatCard: View {
    public let title: String
    public let value: String
    public let icon: String
    public let color: Color

    public init(title: String, value: String, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: 14)
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard(title: "Logs", value: "25", icon: "list.bullet", color: AppTheme.signalTint)
        StatCard(title: "Top Signal", value: "Wagging", icon: "star.fill", color: AppTheme.accentWarm)
        StatCard(title: "Top Context", value: "Feeding", icon: "tag.fill", color: AppTheme.contextTint)
    }
    .padding()
}
