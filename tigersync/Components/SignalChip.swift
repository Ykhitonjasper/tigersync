import SwiftUI

public struct SignalChip: View {
    public let signal: Signal
    public var isSelected = false
    public var onTap: () -> Void = {}

    public init(signal: Signal, isSelected: Bool = false, onTap: @escaping () -> Void = {}) {
        self.signal = signal
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: signal.icon)
                    .font(.caption2.weight(.semibold))
                Text(signal.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? AppTheme.bannerBrown : .primary)
            .background(isSelected ? AppTheme.signalTint.opacity(0.22) : Color.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.chipRadius, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.signalTint.opacity(0.55) : AppTheme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        SignalChip(signal: MockData.signals[0], isSelected: true)
        SignalChip(signal: MockData.signals[1])
        SignalChip(signal: MockData.signals[4])
    }
    .padding()
}
