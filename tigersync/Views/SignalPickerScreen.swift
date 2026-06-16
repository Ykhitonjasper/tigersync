import SwiftUI

public struct SignalPickerScreen: View {
    @Environment(\.dismiss) private var dismiss
    public let allSignals: [Signal]
    @Binding public var selected: [Signal]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public init(allSignals: [Signal], selected: Binding<[Signal]>) {
        self.allSignals = allSignals
        self._selected = selected
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: AppTheme.sectionSpacing) {
                    ForEach(SignalCategory.allCases, id: \.self) { category in
                        categorySection(category)
                    }
                }
                .padding(16)
            }
            .screenChrome()
            .navigationTitle("Behaviour Signals")
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

    private func categorySection(_ category: SignalCategory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(category.displayName, systemImage: category.icon)
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(allSignals.filter { $0.category == category }) { signal in
                    SignalTile(
                        signal: signal,
                        isSelected: selected.contains(where: { $0.id == signal.id }),
                        onTap: { toggleSignal(signal) }
                    )
                }
            }
        }
    }

    private func toggleSignal(_ signal: Signal) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let idx = selected.firstIndex(where: { $0.id == signal.id }) {
                selected.remove(at: idx)
            } else {
                selected.append(signal)
            }
        }
    }
}

private struct SignalTile: View {
    let signal: Signal
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: signal.icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(isSelected ? AppTheme.signalTint : .secondary)
                Text(signal.name)
                    .font(.caption.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(AppTheme.signalTint)
                }
            }
            .padding(12)
            .background(isSelected ? AppTheme.signalTint.opacity(0.12) : Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.signalTint.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SignalPickerScreen(allSignals: MockData.signals, selected: .constant([]))
}
