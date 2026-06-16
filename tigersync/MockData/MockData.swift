import Foundation

public enum MockData {
    // MARK: - Pets
    public static let pets: [Pet] = [
        Pet(id: 1, name: "Buddy", species: .dog, breed: "Golden Retriever", colorHex: "#F4A460"),
        Pet(id: 2, name: "Whiskers", species: .cat, breed: "British Shorthair", colorHex: "#87CEEB"),
        Pet(id: 3, name: "Polly", species: .bird, breed: "Cockatiel", colorHex: "#90EE90"),
        Pet(id: 4, name: "Clover", species: .rabbit, breed: "Holland Lop", colorHex: "#DDA0DD")
    ]

    // MARK: - Signals
    public static let signals: [Signal] = [
        // Tail
        Signal(id: 1, category: .tail, name: "Wagging", icon: "arrow.left.and.right"),
        Signal(id: 2, category: .tail, name: "Tucked", icon: "arrow.down.to.line"),
        Signal(id: 3, category: .tail, name: "Upright", icon: "arrow.up"),
        Signal(id: 4, category: .tail, name: "Slow Sway", icon: "arrow.trianglehead.2.clockwise.rotate.90"),
        // Ears
        Signal(id: 5, category: .ears, name: "Perked", icon: "ear"),
        Signal(id: 6, category: .ears, name: "Pinned", icon: "chevron.down"),
        Signal(id: 7, category: .ears, name: "Swiveling", icon: "arrow.clockwise"),
        Signal(id: 8, category: .ears, name: "Relaxed", icon: "minus.circle"),
        // Vocal
        Signal(id: 9, category: .vocal, name: "Barking", icon: "speaker.wave.2.fill"),
        Signal(id: 10, category: .vocal, name: "Purring", icon: "waveform"),
        Signal(id: 11, category: .vocal, name: "Whining", icon: "exclamationmark.bubble"),
        Signal(id: 12, category: .vocal, name: "Chirping", icon: "bird.fill"),
        // Posture
        Signal(id: 13, category: .posture, name: "Crouched", icon: "figure.fall"),
        Signal(id: 14, category: .posture, name: "Stretched", icon: "figure.walk"),
        Signal(id: 15, category: .posture, name: "Bowing", icon: "figure.play"),
        Signal(id: 16, category: .posture, name: "Curled Up", icon: "moon.zzz")
    ]

    // MARK: - Context Tags
    public static let contextTags: [ContextTag] = [
        ContextTag(id: 1, name: "Feeding", icon: "fork.knife"),
        ContextTag(id: 2, name: "Guest", icon: "person.2"),
        ContextTag(id: 3, name: "Walking", icon: "figure.walk"),
        ContextTag(id: 4, name: "Sleeping", icon: "moon.zzz"),
        ContextTag(id: 5, name: "Play", icon: "sportscourt"),
        ContextTag(id: 6, name: "Vet", icon: "cross.case"),
        ContextTag(id: 7, name: "Alone", icon: "house"),
        ContextTag(id: 8, name: "Training", icon: "graduationcap"),
        ContextTag(id: 9, name: "Grooming", icon: "scissors"),
        ContextTag(id: 10, name: "Car Ride", icon: "car")
    ]

    // MARK: - Behaviour Logs
    public static let logs: [BehaviourLog] = [
        // Buddy logs
        BehaviourLog(id: 1, petId: 1, signalIds: [1, 5], contextTagIds: [2], timestamp: Date().addingTimeInterval(-3600), note: "Excited to see our friend"),
        BehaviourLog(id: 2, petId: 1, signalIds: [1, 9], contextTagIds: [5], timestamp: Date().addingTimeInterval(-7200), note: "Play barking"),
        BehaviourLog(id: 3, petId: 1, signalIds: [1, 14], contextTagIds: [3], timestamp: Date().addingTimeInterval(-86400), note: ""),
        BehaviourLog(id: 4, petId: 1, signalIds: [2, 6], contextTagIds: [6], timestamp: Date().addingTimeInterval(-172800), note: "Scared at the vet"),
        BehaviourLog(id: 5, petId: 1, signalIds: [1, 5], contextTagIds: [2], timestamp: Date().addingTimeInterval(-259200), note: "Guest again, same reaction"),
        BehaviourLog(id: 6, petId: 1, signalIds: [3, 9], contextTagIds: [1], timestamp: Date().addingTimeInterval(-345600), note: "Waiting for food"),
        BehaviourLog(id: 7, petId: 1, signalIds: [1, 14], contextTagIds: [5], timestamp: Date().addingTimeInterval(-432000), note: ""),
        BehaviourLog(id: 8, petId: 1, signalIds: [2, 13], contextTagIds: [6], timestamp: Date().addingTimeInterval(-518400), note: ""),
        BehaviourLog(id: 9, petId: 1, signalIds: [1, 5], contextTagIds: [2], timestamp: Date().addingTimeInterval(-604800), note: "Always happy with guests"),

        // Whiskers logs
        BehaviourLog(id: 10, petId: 2, signalIds: [6, 10], contextTagIds: [7], timestamp: Date().addingTimeInterval(-1800), note: "Purring but ears back"),
        BehaviourLog(id: 11, petId: 2, signalIds: [4, 10], contextTagIds: [4], timestamp: Date().addingTimeInterval(-5400), note: "Slow tail sway while napping"),
        BehaviourLog(id: 12, petId: 2, signalIds: [6, 16], contextTagIds: [7], timestamp: Date().addingTimeInterval(-86400), note: "Curled up alone"),
        BehaviourLog(id: 13, petId: 2, signalIds: [3, 5], contextTagIds: [2], timestamp: Date().addingTimeInterval(-172800), note: "Alert to guest"),
        BehaviourLog(id: 14, petId: 2, signalIds: [6, 11], contextTagIds: [7], timestamp: Date().addingTimeInterval(-259200), note: "Whining when alone"),
        BehaviourLog(id: 15, petId: 2, signalIds: [10, 8], contextTagIds: [1], timestamp: Date().addingTimeInterval(-345600), note: "Relaxed at feeding"),
        BehaviourLog(id: 16, petId: 2, signalIds: [6, 16], contextTagIds: [7], timestamp: Date().addingTimeInterval(-432000), note: ""),
        BehaviourLog(id: 17, petId: 2, signalIds: [3, 5], contextTagIds: [2], timestamp: Date().addingTimeInterval(-518400), note: ""),
        BehaviourLog(id: 18, petId: 2, signalIds: [6, 11], contextTagIds: [7], timestamp: Date().addingTimeInterval(-604800), note: "Same alone pattern"),

        // Polly logs
        BehaviourLog(id: 19, petId: 3, signalIds: [12, 3], contextTagIds: [2], timestamp: Date().addingTimeInterval(-900), note: "Chirping at guest"),
        BehaviourLog(id: 20, petId: 3, signalIds: [12, 14], contextTagIds: [1], timestamp: Date().addingTimeInterval(-10800), note: "Stretching after breakfast"),
        BehaviourLog(id: 21, petId: 3, signalIds: [7, 12], contextTagIds: [5], timestamp: Date().addingTimeInterval(-86400), note: ""),
        BehaviourLog(id: 22, petId: 3, signalIds: [3, 12], contextTagIds: [2], timestamp: Date().addingTimeInterval(-172800), note: ""),
        BehaviourLog(id: 23, petId: 3, signalIds: [16, 8], contextTagIds: [4], timestamp: Date().addingTimeInterval(-345600), note: "Curled and relaxed"),
        BehaviourLog(id: 24, petId: 3, signalIds: [12, 15], contextTagIds: [1], timestamp: Date().addingTimeInterval(-432000), note: "Bowing before food"),
        BehaviourLog(id: 25, petId: 3, signalIds: [12, 7], contextTagIds: [2], timestamp: Date().addingTimeInterval(-518400), note: ""),

        // Clover logs
        BehaviourLog(id: 26, petId: 4, signalIds: [14, 8], contextTagIds: [4], timestamp: Date().addingTimeInterval(-2400), note: "Flopped after floor time"),
        BehaviourLog(id: 27, petId: 4, signalIds: [13, 6], contextTagIds: [9], timestamp: Date().addingTimeInterval(-14400), note: "Ears back during nail trim"),
        BehaviourLog(id: 28, petId: 4, signalIds: [9, 11], contextTagIds: [7], timestamp: Date().addingTimeInterval(-43200), note: "Thumping when left alone"),
        BehaviourLog(id: 29, petId: 4, signalIds: [14, 8], contextTagIds: [5], timestamp: Date().addingTimeInterval(-129600), note: "Binky after play tunnel"),
        BehaviourLog(id: 30, petId: 4, signalIds: [13, 6], contextTagIds: [9], timestamp: Date().addingTimeInterval(-216000), note: "Grooming stress again"),
        BehaviourLog(id: 31, petId: 4, signalIds: [9, 11], contextTagIds: [7], timestamp: Date().addingTimeInterval(-302400), note: "Alone thumping pattern"),
        BehaviourLog(id: 32, petId: 4, signalIds: [5, 7], contextTagIds: [2], timestamp: Date().addingTimeInterval(-388800), note: "Curious about guest"),
        BehaviourLog(id: 33, petId: 4, signalIds: [14, 8], contextTagIds: [1], timestamp: Date().addingTimeInterval(-475200), note: "Relaxed after hay"),
        BehaviourLog(id: 34, petId: 4, signalIds: [13, 6], contextTagIds: [10], timestamp: Date().addingTimeInterval(-561600), note: "Car ride freeze"),
        BehaviourLog(id: 35, petId: 4, signalIds: [9, 11], contextTagIds: [7], timestamp: Date().addingTimeInterval(-648000), note: ""),

        // Additional cross-pet logs for weekly insights
        BehaviourLog(id: 36, petId: 1, signalIds: [7, 13], contextTagIds: [8], timestamp: Date().addingTimeInterval(-2592000), note: "Yawning during training"),
        BehaviourLog(id: 37, petId: 2, signalIds: [6, 16], contextTagIds: [9], timestamp: Date().addingTimeInterval(-2678400), note: "Grooming tolerance low"),
        BehaviourLog(id: 38, petId: 1, signalIds: [2, 6], contextTagIds: [10], timestamp: Date().addingTimeInterval(-2764800), note: "Car stress"),
        BehaviourLog(id: 39, petId: 3, signalIds: [12, 9], contextTagIds: [7], timestamp: Date().addingTimeInterval(-2851200), note: "Screaming alone"),
        BehaviourLog(id: 40, petId: 2, signalIds: [4, 10], contextTagIds: [8], timestamp: Date().addingTimeInterval(-2937600), note: "Slow sway in training")
    ]

    // MARK: - Correlations
    public static let correlations: [Correlation] = [
        Correlation(id: 1, petId: 1, signalIds: [1, 5], contextTagIds: [2], matchCount: 3, totalOpportunity: 3, confidence: 1.0),
        Correlation(id: 2, petId: 1, signalIds: [2, 6], contextTagIds: [6], matchCount: 2, totalOpportunity: 2, confidence: 1.0),
        Correlation(id: 3, petId: 2, signalIds: [6, 16], contextTagIds: [7], matchCount: 2, totalOpportunity: 3, confidence: 0.67),
        Correlation(id: 4, petId: 2, signalIds: [3, 5], contextTagIds: [2], matchCount: 2, totalOpportunity: 2, confidence: 1.0),
        Correlation(id: 5, petId: 3, signalIds: [12, 3], contextTagIds: [2], matchCount: 2, totalOpportunity: 3, confidence: 0.67),
        Correlation(id: 6, petId: 3, signalIds: [12, 14], contextTagIds: [1], matchCount: 2, totalOpportunity: 3, confidence: 0.67),
        Correlation(id: 7, petId: 4, signalIds: [13, 6], contextTagIds: [9], matchCount: 2, totalOpportunity: 2, confidence: 1.0),
        Correlation(id: 8, petId: 4, signalIds: [9, 11], contextTagIds: [7], matchCount: 3, totalOpportunity: 3, confidence: 1.0),
        Correlation(id: 9, petId: 4, signalIds: [14, 8], contextTagIds: [4], matchCount: 2, totalOpportunity: 3, confidence: 0.67)
    ]

    // MARK: - Helpers
    public static func signals(for ids: [Int]) -> [Signal] {
        signals.filter { ids.contains($0.id) }
    }

    public static func contextTags(for ids: [Int]) -> [ContextTag] {
        contextTags.filter { ids.contains($0.id) }
    }

    public static func pet(for id: Int) -> Pet? {
        pets.first(where: { $0.id == id })
    }

    public static func logs(for petId: Int) -> [BehaviourLog] {
        logs.filter { $0.petId == petId }.sorted { $0.timestamp > $1.timestamp }
    }

    public static func correlations(for petId: Int) -> [Correlation] {
        correlations.filter { $0.petId == petId }.sorted { $0.confidence > $1.confidence }
    }
}
