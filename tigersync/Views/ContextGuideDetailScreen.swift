import SwiftUI

public struct ContextGuideDetailScreen: View {
    let guide: ContextGuidesData.ContextGuide

    init(guide: ContextGuidesData.ContextGuide) {
        self.guide = guide
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                header
                DetailBulletSection(
                    title: "Typical signals",
                    icon: "waveform.path",
                    items: guide.typicalSignals,
                    tint: AppTheme.signalTint
                )
                DetailBulletSection(
                    title: "Logging tips",
                    icon: "pencil.and.list.clipboard",
                    items: guide.loggingTips
                )
                DetailBulletSection(
                    title: "Reduce stress",
                    icon: "heart.fill",
                    items: guide.reduceStress,
                    tint: AppTheme.accentWarm
                )
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle(guide.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: guide.icon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppTheme.contextTint)
                .frame(width: 48, height: 48)
                .background(AppTheme.contextTint.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Text(guide.overview)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardSurface(padding: 16)
    }
}

#Preview {
    NavigationStack {
        if let guide = ContextGuidesData.guide(for: 1) {
            ContextGuideDetailScreen(guide: guide)
                .tint(AppTheme.accent)
        }
    }
}
