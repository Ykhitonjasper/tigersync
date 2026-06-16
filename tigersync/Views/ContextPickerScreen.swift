import SwiftUI

public struct ContextPickerScreen: View {
    @Environment(\.dismiss) private var dismiss
    public let allTags: [ContextTag]
    @Binding public var selected: [ContextTag]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public init(allTags: [ContextTag], selected: Binding<[ContextTag]>) {
        self.allTags = allTags
        self._selected = selected
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(allTags) { tag in
                        ContextTile(
                            tag: tag,
                            isSelected: selected.contains(where: { $0.id == tag.id }),
                            onTap: { toggleTag(tag) }
                        )
                    }
                }
                .padding(16)
            }
            .screenChrome()
            .navigationTitle("Context")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .tint(AppTheme.accent)
    }

    private func toggleTag(_ tag: ContextTag) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let idx = selected.firstIndex(where: { $0.id == tag.id }) {
                selected.remove(at: idx)
            } else {
                selected.append(tag)
            }
        }
    }
}

private struct ContextTile: View {
    let tag: ContextTag
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: tag.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? AppTheme.contextTint : .secondary)
                Text(tag.name)
                    .font(.caption.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.contextTint)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? AppTheme.contextTint.opacity(0.12) : Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.contextTint.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContextPickerScreen(allTags: MockData.contextTags, selected: .constant([]))
}
