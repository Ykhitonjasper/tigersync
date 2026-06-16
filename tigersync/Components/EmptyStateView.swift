import SwiftUI

public struct EmptyStateView: View {
    public let icon: String
    public let title: String
    public let subtitle: String

    public init(icon: String, title: String, subtitle: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(AppTheme.accentGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: AppTheme.accentWarm.opacity(0.3), radius: 6, y: 3)
                .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: 28)
    }
}

#Preview {
    EmptyStateView(
        icon: "pawprint",
        title: "No correlations yet",
        subtitle: "Log more behaviour moments to discover patterns"
    )
    .padding()
}
