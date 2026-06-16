import SwiftUI

struct InfoChip: View {
    let icon: String
    let name: String
    var tint: Color = AppTheme.signalTint

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2.weight(.semibold))
            Text(name)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .foregroundStyle(tint)
        .background(tint.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
    }
}

#Preview {
    HStack {
        InfoChip(icon: "arrow.left.and.right", name: "Wagging")
        InfoChip(icon: "fork.knife", name: "Feeding", tint: AppTheme.contextTint)
    }
    .padding()
}
