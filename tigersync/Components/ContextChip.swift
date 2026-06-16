import SwiftUI

public struct ContextChip: View {
    public let tag: ContextTag
    public var isSelected = false
    public var onTap: () -> Void = {}

    public init(tag: ContextTag, isSelected: Bool = false, onTap: @escaping () -> Void = {}) {
        self.tag = tag
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: tag.icon)
                    .font(.caption2.weight(.semibold))
                Text(tag.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? .white : .primary)
            .background(isSelected ? AppTheme.contextTint : Color.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.contextTint.opacity(0.7) : AppTheme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        ContextChip(tag: MockData.contextTags[0], isSelected: true)
        ContextChip(tag: MockData.contextTags[1])
        ContextChip(tag: MockData.contextTags[4])
    }
    .padding()
}
