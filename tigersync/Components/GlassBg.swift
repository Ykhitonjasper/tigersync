import SwiftUI

struct GlassBg: View {
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient

            Circle()
                .fill(AppTheme.accent.opacity(0.08))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -120, y: -180)

            Circle()
                .fill(AppTheme.accentGold.opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 140, y: 120)

            Circle()
                .fill(AppTheme.contextTint.opacity(0.06))
                .frame(width: 180, height: 180)
                .blur(radius: 40)
                .offset(x: -80, y: 320)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        GlassBg()
        Text("Preview")
    }
}
