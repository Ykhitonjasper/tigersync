import SwiftUI

public struct ConfidenceBar: View {
    public let value: Double
    public let color: Color

    public init(value: Double, color: Color? = nil) {
        self.value = value
        self.color = color ?? AppTheme.confidenceColor(for: value)
    }

    @State private var animatedValue: Double = 0

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.12))
                    .frame(height: 8)

                Capsule()
                    .fill(color)
                    .frame(width: max(0, geo.size.width * animatedValue), height: 8)
            }
        }
        .frame(height: 8)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { _, newValue in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                animatedValue = newValue
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ConfidenceBar(value: 1.0)
        ConfidenceBar(value: 0.67)
        ConfidenceBar(value: 0.3)
    }
    .padding()
}
