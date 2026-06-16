import SwiftUI

enum AppTheme {
    // Fortune Tiger brand — red, gold, green from App Store creatives
    static let accent = Color(hex: "#DC2626")
    static let accentGold = Color(hex: "#FBBF24")
    static let accentWarm = Color(hex: "#FF6B00")
    static let signalTint = Color(hex: "#F59E0B")
    static let contextTint = Color(hex: "#22C55E")
    static let bannerBrown = Color(hex: "#5C2E1A")

    static let cardRadius: CGFloat = 16
    static let chipRadius: CGFloat = 8
    static let sectionSpacing: CGFloat = 24

    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [accentGold, accentWarm],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "#FFF5F0"),
                Color(hex: "#FFE4DC"),
                Color(hex: "#FFD1C7")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var cardBackground: Color {
        Color.white
    }

    static var cardBorder: Color {
        accentGold.opacity(0.28)
    }

    static func confidenceColor(for value: Double) -> Color {
        if value >= 0.8 { return contextTint }
        if value >= 0.5 { return accentGold }
        return accent
    }
}
