import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String?
    var trailing: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.caption.weight(.semibold))
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionHeader(title: "Recent Moments", subtitle: "Last 10 entries", trailing: "12 total")
        SectionHeader(title: "Your Pets", actionTitle: "See all") {}
    }
    .padding()
}
