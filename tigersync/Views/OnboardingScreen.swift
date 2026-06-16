import SwiftUI

public struct OnboardingScreen: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var page = 0
    @State private var hapticTrigger = 0

    private let pages: [(title: String, subtitle: String, icon: String)] = [
        (
            "Decode behaviour",
            "Log tail wags, ear positions, and vocalizations in seconds. Build a personal dictionary for each pet.",
            "pawprint.circle.fill"
        ),
        (
            "Discover patterns",
            "tigersync finds correlations between signals and contexts — guest visits, walks, vet trips, and more.",
            "chart.line.uptrend.xyaxis"
        ),
        (
            "Learn with confidence",
            "Species reference, behaviour guides, and weekly insights help you respond — not guess.",
            "book.closed.fill"
        )
    ]

    public init() {}

    public var body: some View {
        ZStack {
            GlassBg()

            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("tigersync")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.accentGold)
                        .textCase(.uppercase)
                        .tracking(1.2)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(AppTheme.bannerBrown)
                        .clipShape(Capsule())
                    Text("Следи за своим питомцем!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.accent)
                }
                .padding(.top, 24)

                TabView(selection: $page) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack(spacing: 24) {
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 44, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 88, height: 88)
                                .background(AppTheme.accentGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                .shadow(color: AppTheme.accentWarm.opacity(0.35), radius: 10, y: 4)

                            VStack(spacing: 12) {
                                Text(pages[index].title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)

                                Text(pages[index].subtitle)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 24)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(maxHeight: 400)

                Text("All data stays on your device. Privacy Policy and Terms are in Settings.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    hapticTrigger += 1
                    if page < pages.count - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            page += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                        HapticFeedback.success()
                    }
                } label: {
                    Text(page < pages.count - 1 ? "Continue" : "Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
                .accessibilityIdentifier("onboarding.continue")
                .sensoryFeedback(.impact(weight: .light), trigger: hapticTrigger)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .tint(AppTheme.accent)
    }
}

#Preview {
    OnboardingScreen()
}
