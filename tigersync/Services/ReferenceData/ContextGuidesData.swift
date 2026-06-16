import Foundation

enum ContextGuidesData {
    struct ContextGuide: Identifiable {
        let id: Int
        let name: String
        let icon: String
        let overview: String
        let typicalSignals: [String]
        let loggingTips: [String]
        let reduceStress: [String]
    }

    static let guides: [ContextGuide] = [
        ContextGuide(
            id: 1,
            name: "Feeding",
            icon: "fork.knife",
            overview: "Mealtime concentrates anticipation, resource guarding, and post-meal mood shifts. Logging around feeding reveals routine-driven behaviour.",
            typicalSignals: ["Pacing before bowl", "Whining or vocalizing", "Guarding posture", "Play bow after eating"],
            loggingTips: [
                "Note time relative to scheduled meal",
                "Record who was present during feeding",
                "Separate guarding from excitement in notes"
            ],
            reduceStress: [
                "Feed in quiet zones away from foot traffic",
                "Use slow feeders for gulping dogs",
                "Separate animals if guarding appears"
            ]
        ),
        ContextGuide(
            id: 2,
            name: "Guest",
            icon: "person.2",
            overview: "Visitor arrivals spike social stress for shy animals and excitement for outgoing ones. Patterns here guide guest protocols.",
            typicalSignals: ["Barking at door", "Hiding", "Tail tuck", "Overgreeting jump"],
            loggingTips: [
                "Log within 15 minutes of guest entry",
                "Note guest behaviour: ignored pet vs approached",
                "Track recovery time after guests leave"
            ],
            reduceStress: [
                "Pre-exercise before arrivals",
                "Guest ignores pet until approach",
                "Provide escape room with resources"
            ]
        ),
        ContextGuide(
            id: 3,
            name: "Walking",
            icon: "figure.walk",
            overview: "Outdoor walks combine novelty, triggers, and physical needs. Leash tension amplifies reactive signals.",
            typicalSignals: ["Pulling", "Sniffing freeze", "Stiff tail at dogs", "Shake-off after trigger"],
            loggingTips: [
                "Tag route type: familiar vs new",
                "Note other animals encountered",
                "Rate leash tension high/medium/low"
            ],
            reduceStress: [
                "Allow decompression sniff breaks",
                "Increase distance from triggers",
                "Use front-clip harness for pullers"
            ]
        ),
        ContextGuide(
            id: 4,
            name: "Sleeping",
            icon: "moon.zzz",
            overview: "Rest contexts expose whether sleep is restorative or vigilant. Disrupted sleep correlates with next-day reactivity.",
            typicalSignals: ["Circling before lie-down", "Flopping", "One-foot bird sleep", "Startle to noise"],
            loggingTips: [
                "Log location: bed, crate, window",
                "Note interruptions and duration",
                "Distinguish flop from freeze"
            ],
            reduceStress: [
                "Keep sleep area dark and cool",
                "Avoid late high-arousal play",
                "Maintain consistent bedtime"
            ]
        ),
        ContextGuide(
            id: 5,
            name: "Play",
            icon: "sportscourt",
            overview: "Play reveals social skills, bite inhibition, and overstimulation thresholds. Meta-signals separate fun from conflict.",
            typicalSignals: ["Play bow", "Bouncy movement", "Growl during tug", "Tail tuck mid-play"],
            loggingTips: [
                "Record play partner species and size",
                "Note who initiated and who ended",
                "Log shake-off within 5 minutes after"
            ],
            reduceStress: [
                "Pause every 20 seconds for breath check",
                "End before exhaustion",
                "Use toys instead of hands"
            ]
        ),
        ContextGuide(
            id: 6,
            name: "Vet",
            icon: "cross.case",
            overview: "Clinical environments stack novel smells, restraint, and pain. Tracking vet-specific signals informs future visits.",
            typicalSignals: ["Pinned ears", "Whale eye", "Freezing", "Panting"],
            loggingTips: [
                "Log each handling step separately",
                "Note treats used and acceptance",
                "Record recovery time after return home"
            ],
            reduceStress: [
                "Carrier train in advance",
                "Request quiet appointment slots",
                "Bring behaviour log for staff"
            ]
        ),
        ContextGuide(
            id: 7,
            name: "Alone",
            icon: "house",
            overview: "Alone-time behaviour exposes separation distress, boredom, and self-soothing. Film when possible for accuracy.",
            typicalSignals: ["Vocalizing", "Destructive chewing", "Over-grooming", "Thumping"],
            loggingTips: [
                "Log departure and return times",
                "Note duration of distress signals",
                "Separate first 10 minutes from later period"
            ],
            reduceStress: [
                "Gradual absence training",
                "Food puzzles at departure",
                "Avoid emotional hellos/goodbyes"
            ]
        ),
        ContextGuide(
            id: 8,
            name: "Training",
            icon: "graduationcap",
            overview: "Training sessions reveal focus, frustration, and learning pace. Stress signals mean criteria are too hard.",
            typicalSignals: ["Yawning", "Sniffing displacement", "Refusal to sit", "Eager offering"],
            loggingTips: [
                "Log session length and reinforcer type",
                "Note error rate before stress signals",
                "Record break behaviour"
            ],
            reduceStress: [
                "Keep sessions under five minutes",
                "Lower criteria when yawning appears",
                "End on success"
            ]
        ),
        ContextGuide(
            id: 9,
            name: "Grooming",
            icon: "scissors",
            overview: "Handling for nails, brushing, or bathing triggers restraint sensitivity. Build tolerance in micro-sessions.",
            typicalSignals: ["Mouth licking", "Whale eye", "Freezing", "Soft tooth grinding"],
            loggingTips: [
                "Tag body zone: paws, ears, belly",
                "Note tool used: brush, clippers, water",
                "Score tolerance 1–5 each session"
            ],
            reduceStress: [
                "Pair touch with treats at non-trigger zones",
                "Stop before threshold",
                "Professional groomer desensitization plans"
            ]
        ),
        ContextGuide(
            id: 10,
            name: "Car Ride",
            icon: "car",
            overview: "Travel combines motion, confinement, and destination uncertainty. Many pets predict vet from car alone.",
            typicalSignals: ["Drooling", "Panting", "Vocalizing", "Relaxed settle"],
            loggingTips: [
                "Log destination: vet, park, home return",
                "Note carrier vs seat harness",
                "Track improvement trip by trip"
            ],
            reduceStress: [
                "Short positive trips to park",
                "Non-slip bedding in carrier",
                "Calm music at moderate volume"
            ]
        )
    ]

    static func guide(for contextId: Int) -> ContextGuide? {
        guides.first { $0.id == contextId }
    }

    static func guide(matching name: String) -> ContextGuide? {
        guides.first { $0.name.lowercased() == name.lowercased() }
    }
}
