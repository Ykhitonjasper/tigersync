import SwiftUI

struct CardSurface: ViewModifier {
    var padding: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                    .strokeBorder(AppTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: AppTheme.accent.opacity(0.06), radius: 8, y: 3)
    }
}

extension View {
    func cardSurface(padding: CGFloat = 0) -> some View {
        modifier(CardSurface(padding: padding))
    }
}
