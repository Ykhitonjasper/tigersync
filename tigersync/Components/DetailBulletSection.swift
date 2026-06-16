import SwiftUI

struct DetailBulletSection: View {
    let title: String
    let icon: String
    let items: [String]
    var tint: Color = AppTheme.accent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(tint)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .cardSurface(padding: 14)
        }
    }
}

#Preview {
    if let guide = ContextGuidesData.guide(for: 1) {
        DetailBulletSection(
            title: "Logging tips",
            icon: "pencil.and.list.clipboard",
            items: guide.loggingTips
        )
        .padding()
    }
}
