import SwiftUI

public struct BehaviourGuideDetailScreen: View {
    let guide: BehaviourGuidesData.Guide

    init(guide: BehaviourGuidesData.Guide) {
        self.guide = guide
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                header
                ForEach(guide.sections) { section in
                    sectionView(section)
                }
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle(guide.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: guide.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 36, height: 36)
                    .background(AppTheme.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                if let species = guide.species {
                    Image(systemName: species.icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.accentWarm)
                        .frame(width: 36, height: 36)
                        .background(AppTheme.accentWarm.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                Spacer()

                Text("\(guide.readMinutes) min read")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundStyle(AppTheme.accent)
                    .background(AppTheme.accent.opacity(0.1))
                    .clipShape(Capsule())
            }

            Text(guide.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .cardSurface(padding: 16)
    }

    private func sectionView(_ section: BehaviourGuidesData.Section) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.heading)
                .font(.title3.weight(.semibold))

            Text(section.body)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            if !section.bulletPoints.isEmpty {
                DetailBulletSection(
                    title: "Key points",
                    icon: "checkmark.circle",
                    items: section.bulletPoints
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        if let guide = BehaviourGuidesData.guide(for: 1) {
            BehaviourGuideDetailScreen(guide: guide)
                .tint(AppTheme.accent)
        }
    }
}
