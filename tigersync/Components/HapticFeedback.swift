import SwiftUI
import UIKit

enum HapticFeedback {
    static func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func mediumImpact() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

extension View {
    func hapticOnChange<V: Equatable>(of value: V, style: SensoryFeedback = .impact(weight: .light)) -> some View {
        sensoryFeedback(style, trigger: value)
    }
}
