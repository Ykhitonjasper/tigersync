import SwiftUI

public struct LogRow: View {
    public let log: BehaviourLog
    public let petName: String
    public let petColor: Color

    public init(log: BehaviourLog, petName: String, petColor: Color) {
        self.log = log
        self.petName = petName
        self.petColor = petColor
    }

    private var signals: [Signal] { MockData.signals(for: log.signalIds) }
    private var contexts: [ContextTag] { MockData.contextTags(for: log.contextTagIds) }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(petColor)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(petName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(log.timestamp.relativeString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !signals.isEmpty || !contexts.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(signals) { signal in
                            InfoChip(icon: signal.icon, name: signal.name, tint: AppTheme.signalTint)
                        }
                        ForEach(contexts) { tag in
                            InfoChip(icon: tag.icon, name: tag.name, tint: AppTheme.contextTint)
                        }
                    }
                }

                if !log.note.isEmpty {
                    Text(log.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .cardSurface(padding: 14)
    }
}

#Preview {
    VStack(spacing: 8) {
        LogRow(
            log: MockData.logs[0],
            petName: "Buddy",
            petColor: Color(hex: "#F4A460")
        )
        LogRow(
            log: MockData.logs[10],
            petName: "Whiskers",
            petColor: Color(hex: "#87CEEB")
        )
    }
    .padding()
}
