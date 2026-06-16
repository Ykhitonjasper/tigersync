import SwiftUI

public struct ContextGuideListScreen: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                SectionHeader(
                    title: "Context Guides",
                    subtitle: "What to log in common situations",
                    trailing: "\(ContextGuidesData.guides.count) guides"
                )

                LazyVStack(spacing: 12) {
                    ForEach(ContextGuidesData.guides) { guide in
                        NavigationLink(destination: ContextGuideDetailScreen(guide: guide)) {
                            contextGuideRow(guide)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Context Guides")
        .navigationBarTitleDisplayMode(.large)
    }

    private func contextGuideRow(_ guide: ContextGuidesData.ContextGuide) -> some View {
        HStack(spacing: 14) {
            Image(systemName: guide.icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.contextTint)
                .frame(width: 36, height: 36)
                .background(AppTheme.contextTint.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(guide.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(guide.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .cardSurface(padding: 14)
    }
}

#Preview {
    NavigationStack {
        ContextGuideListScreen()
            .tint(AppTheme.accent)
    }
}
