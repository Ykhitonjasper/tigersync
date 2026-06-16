import SwiftUI

public struct FABButton: View {
    public let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    @State private var isPressed = false
    @State private var hapticTrigger = 0

    public var body: some View {
        Button {
            hapticTrigger += 1
            action()
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AppTheme.accentGradient)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: AppTheme.accentWarm.opacity(0.45), radius: 12, y: 5)
        }
        .accessibilityLabel("Log behaviour")
        .accessibilityIdentifier("journal.fab")
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .sensoryFeedback(.impact(weight: .medium), trigger: hapticTrigger)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    FABButton(action: {})
        .padding()
        .background(AppTheme.backgroundGradient)
}
