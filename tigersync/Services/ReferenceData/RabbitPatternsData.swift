import Foundation

enum RabbitPatternsData {
    static let patterns: [SpeciesReferenceData.Pattern] = [
        Pattern(id: 201, signal: "Binky (jump + twist)", context: "After exercise", meaning: "Pure joy — explosive jump with mid-air twist or kick.", confidence: "Very common", category: "Play", actionTip: "Safe open space encourages more binkies."),
        Pattern(id: 202, signal: "Thumping hind leg", context: "Sudden noise", meaning: "Alarm signal — warns other rabbits and marks danger.", confidence: "Very common", category: "Alert", actionTip: "Identify trigger and reduce exposure."),
        Pattern(id: 203, signal: "Flopping on side", context: "Quiet evening", meaning: "Deep relaxation — rabbit feels completely safe.", confidence: "Very common", category: "Rest", actionTip: "Do not disturb; flopping is high trust."),
        Pattern(id: 204, signal: "Chin rubbing on objects", context: "New furniture", meaning: "Scent marking — chin glands claim territory.", confidence: "Very common", category: "Territory", actionTip: "Allow marking on safe items."),
        Pattern(id: 205, signal: "Teeth grinding (soft)", context: "While being petted", meaning: "Purring equivalent — contentment during gentle grooming.", confidence: "Common", category: "Bonding", actionTip: "Continue gentle strokes along cheeks."),
        Pattern(id: 206, signal: "Teeth grinding (loud)", context: "After handling", meaning: "Pain indicator — distinct from quiet purring grind.", confidence: "Common", category: "Health", actionTip: "Stop handling; consult a rabbit-savvy vet."),
        Pattern(id: 207, signal: "Ears forward + frozen", context: "Unfamiliar footsteps", meaning: "Alert listening — assessing potential threat.", confidence: "Very common", category: "Ears", actionTip: "Speak softly; let rabbit decide to approach."),
        Pattern(id: 208, signal: "Ears flat back", context: "Forced pickup", meaning: "Fear or anger — rabbits prefer ground contact.", confidence: "Very common", category: "Stress", actionTip: "Interact at floor level; avoid lifting."),
        Pattern(id: 209, signal: "Nudging with nose", context: "Empty food bowl", meaning: "Polite demand — requesting refill or attention.", confidence: "Very common", category: "Routine", actionTip: "Check hay and water before assuming treats."),
        Pattern(id: 210, signal: "Circling feet", context: "Around owner's legs", meaning: "Excitement or hormonal courtship — often with honking.", confidence: "Common", category: "Social", actionTip: "Spay/neuter reduces hormonal circling."),
        Pattern(id: 211, signal: "Honking", context: "Circling behavior", meaning: "Mating or excitement vocalization — soft grunt-like sound.", confidence: "Common", category: "Vocal", actionTip: "Redirect with a treat scatter for foraging."),
        Pattern(id: 212, signal: "Digging at carpet", context: "Before nap", meaning: "Nesting instinct — preparing a resting spot.", confidence: "Very common", category: "Nesting", actionTip: "Provide a dig box with shredded paper."),
        Pattern(id: 213, signal: "Lunging with growl", context: "Hand in cage", meaning: "Territory defense — cage is safe zone.", confidence: "Common", category: "Territory", actionTip: "Open cage door; let rabbit come out voluntarily."),
        Pattern(id: 214, signal: "Licking human skin", context: "Grooming session", meaning: "Affection grooming — rabbit accepts you as family.", confidence: "Common", category: "Bonding", actionTip: "Stay still; sudden moves may end grooming."),
        Pattern(id: 215, signal: "Sprawling legs out", context: "Warm room", meaning: "Heat dissipation — relaxed sprawl on cool surface.", confidence: "Very common", category: "Rest", actionTip: "Ensure ventilation; rabbits overheat easily."),
        Pattern(id: 216, signal: "Hiding in tunnel", context: "After guests arrive", meaning: "Stress retreat — prey animal seeking cover.", confidence: "Very common", category: "Stress", actionTip: "Keep tunnel accessible; don't pull them out."),
        Pattern(id: 217, signal: "Tossing hay", context: "Morning", meaning: "Foraging play — sorting and selecting best pieces.", confidence: "Very common", category: "Foraging", actionTip: "Scatter hay for natural searching behavior."),
        Pattern(id: 218, signal: "Stomping without sound", context: "Watching TV", meaning: "Mild irritation — low-level thump at vibration or sound.", confidence: "Common", category: "Alert", actionTip: "Lower volume or relocate enclosure."),
        Pattern(id: 219, signal: "Periscoping (standing tall)", context: "New object on floor", meaning: "Curiosity — stretching to inspect unfamiliar item.", confidence: "Very common", category: "Exploration", actionTip: "Let rabbit sniff at their pace."),
        Pattern(id: 220, signal: "Rubbing face on floor", context: "After cleaning", meaning: "Re-scenting — replacing lost familiar smells.", confidence: "Common", category: "Territory", actionTip: "Leave a familiar blanket during cleaning.")
    ]

    private typealias Pattern = SpeciesReferenceData.Pattern
}
