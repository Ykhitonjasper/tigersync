import Foundation

enum BehaviourGuidesData {
    struct Guide: Identifiable {
        let id: Int
        let title: String
        let subtitle: String
        let icon: String
        let species: PetSpecies?
        let readMinutes: Int
        let sections: [Section]
    }

    struct Section: Identifiable {
        let id: Int
        let heading: String
        let body: String
        let bulletPoints: [String]
    }

    static let guides: [Guide] = [
        Guide(
            id: 1,
            title: "Reading Tail Language",
            subtitle: "Decode wag speed, height, and stiffness",
            icon: "arrow.left.and.right",
            species: .dog,
            readMinutes: 6,
            sections: [
                Section(
                    id: 1,
                    heading: "Why tails matter",
                    body: "A dog's tail is a mood barometer, but context changes everything. The same wag can mean joy or tension depending on speed, height, and what the rest of the body is doing.",
                    bulletPoints: [
                        "Loose, wide wags at mid height often signal friendly arousal",
                        "High stiff wags can precede reactivity toward dogs or people",
                        "Tucked tails usually indicate fear, pain, or submission"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Common mistakes",
                    body: "Owners often assume any wag is happy. Dogs approaching with a vertical, vibrating tail and tense muscles are not inviting a hug — they are conflicted.",
                    bulletPoints: [
                        "Pair tail reading with ear position and weight distribution",
                        "Log the trigger context every time — patterns emerge fast",
                        "Film short clips; memory distorts speed and height"
                    ]
                )
            ]
        ),
        Guide(
            id: 2,
            title: "Cat Petting Consent",
            subtitle: "Know when to stop before a swat",
            icon: "hand.raised",
            species: .cat,
            readMinutes: 5,
            sections: [
                Section(
                    id: 1,
                    heading: "The petting threshold",
                    body: "Cats tolerate petting for a limited time. Tail twitching, skin rippling, and flattened ears are stop signals — not invitations to pet harder.",
                    bulletPoints: [
                        "Pet cheeks and chin first — safer than long back strokes",
                        "End sessions while the cat still wants more",
                        "A swat after belly exposure is often a revoked consent"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Building trust",
                    body: "Short, predictable sessions teach cats that human hands are safe. Pair petting with treats only when body language stays soft.",
                    bulletPoints: [
                        "Use a three-second rule: pet, pause, watch",
                        "Log which zones your cat prefers over two weeks",
                        "Respect withdrawal — trust compounds slowly"
                    ]
                )
            ]
        ),
        Guide(
            id: 3,
            title: "Bird Screaming vs Contact Calls",
            subtitle: "Separate boredom from flock calls",
            icon: "speaker.wave.3",
            species: .bird,
            readMinutes: 7,
            sections: [
                Section(
                    id: 1,
                    heading: "Normal flock noise",
                    body: "Parrots call to maintain contact with their flock. Morning and evening peaks are natural. Problem screaming is loud, repetitive, and triggered by your return after absence.",
                    bulletPoints: [
                        "Contact calls are brief; screaming loops for minutes",
                        "Covering the cage does not fix underlying loneliness",
                        "Background flock sounds can reduce panic calls"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Enrichment plan",
                    body: "Foraging toys, training sessions, and predictable routines reduce scream frequency more than punishment ever will.",
                    bulletPoints: [
                        "Schedule 10 minutes of training before you leave",
                        "Rotate toys weekly to prevent habituation",
                        "Reward quiet moments — they are easy to miss"
                    ]
                )
            ]
        ),
        Guide(
            id: 4,
            title: "Rabbit Floor Time",
            subtitle: "Why ground-level interaction wins",
            icon: "hare",
            species: .rabbit,
            readMinutes: 5,
            sections: [
                Section(
                    id: 1,
                    heading: "Prey animal logic",
                    body: "Rabbits feel safest with escape routes at ground level. Picking up removes their primary defense — running — and can trigger thrashing injuries.",
                    bulletPoints: [
                        "Sit on the floor and let the rabbit approach you",
                        "Use tunnels and boxes as confidence builders",
                        "Log flopping frequency as a trust metric"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Daily routine",
                    body: "Two to four hours of supervised floor time supports digestion, mood, and bonding. Pair it with hay access and litter box placement.",
                    bulletPoints: [
                        "Bunny-proof cords and toxic plants first",
                        "Morning floor time often reduces evening thumping",
                        "End sessions before the rabbit chooses to hide"
                    ]
                )
            ]
        ),
        Guide(
            id: 5,
            title: "Stress Stacking",
            subtitle: "When small triggers add up",
            icon: "chart.line.uptrend.xyaxis",
            species: nil,
            readMinutes: 8,
            sections: [
                Section(
                    id: 1,
                    heading: "The stacking model",
                    body: "A vet visit alone might be fine. A vet visit after a skipped walk, a new guest, and a loud thunderstorm is a bite risk. Stress is cumulative.",
                    bulletPoints: [
                        "Rate each log's context intensity from 1–3",
                        "Watch for displacement behaviors: yawns, shakes, lip licks",
                        "Recovery days matter as much as trigger days"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Using your journal",
                    body: "tigersync correlations reveal which contexts repeat before stress signals. Export weekly summaries to share with trainers or vets.",
                    bulletPoints: [
                        "Filter patterns by confidence above 70%",
                        "Compare pets individually — siblings differ",
                        "Note recovery behaviors after each stack"
                    ]
                )
            ]
        ),
        Guide(
            id: 6,
            title: "Guest Introductions",
            subtitle: "Safe meetings for shy pets",
            icon: "person.2",
            species: nil,
            readMinutes: 6,
            sections: [
                Section(
                    id: 1,
                    heading: "Before guests arrive",
                    body: "Exercise, a meal, and a quiet zone reduce baseline arousal. Guests should ignore the pet until the pet chooses to approach.",
                    bulletPoints: [
                        "Provide a hideout with water in a low-traffic room",
                        "Ask guests to avoid direct eye contact and leaning",
                        "Log guest-related signals within 30 minutes after"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Multi-species differences",
                    body: "Dogs may need leash management; cats need vertical escape; birds need cage security; rabbits need floor-level exits.",
                    bulletPoints: [
                        "One calm guest beats a loud group for first visits",
                        "Treat scatter rewards brave curiosity in dogs",
                        "End visits before overt fear signals peak"
                    ]
                )
            ]
        ),
        Guide(
            id: 7,
            title: "Vet Visit Prep",
            subtitle: "Lower clinical stress signals",
            icon: "cross.case",
            species: nil,
            readMinutes: 7,
            sections: [
                Section(
                    id: 1,
                    heading: "Carrier training",
                    body: "Leave carriers out with treats inside for days before travel. Covering with a breathable towel reduces visual triggers in waiting rooms.",
                    bulletPoints: [
                        "Practice short car rides that end at home",
                        "Bring familiar bedding — not freshly washed",
                        "Log pinned ears, panting, and freezing each visit"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "At the clinic",
                    body: "Request the quietest appointment slot. Ask staff to move slowly and offer treats before handling.",
                    bulletPoints: [
                        "Bring a behaviour log printout for context",
                        "Note which handling positions triggered whale eye",
                        "Celebrate small wins — calm exits are progress"
                    ]
                )
            ]
        ),
        Guide(
            id: 8,
            title: "Play vs Aggression",
            subtitle: "Meta-signals in social play",
            icon: "sportscourt",
            species: .dog,
            readMinutes: 6,
            sections: [
                Section(
                    id: 1,
                    heading: "Play markers",
                    body: "Play bows, bouncy movement, open mouths without tension, and role reversals mark healthy play. Stiffness and silence are warnings.",
                    bulletPoints: [
                        "Pause play every 20 seconds for breath checks",
                        "Size mismatches need extra monitoring",
                        "Log which play partners produce best recovery"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "When to interrupt",
                    body: "Interrupt if one participant tries to escape repeatedly, pins without reciprocity, or vocalizes in distress.",
                    bulletPoints: [
                        "Use a positive interrupt — treat scatter, not yelling",
                        "Note post-play shake-offs as stress release",
                        "End on calm sniffing, not escalation"
                    ]
                )
            ]
        ),
        Guide(
            id: 9,
            title: "Separation Patterns",
            subtitle: "Alone-time distress signals",
            icon: "house",
            species: nil,
            readMinutes: 8,
            sections: [
                Section(
                    id: 1,
                    heading: "Species-specific signs",
                    body: "Dogs pace and vocalize; cats over-groom or hide; birds scream; rabbits thump repeatedly. Duration and intensity guide severity.",
                    bulletPoints: [
                        "Film a 10-minute alone sample once a week",
                        "Log destruction vs vocalization separately",
                        "Gradual alone-time increments beat long absences"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Intervention ladder",
                    body: "Enrichment first, then routine changes, then professional support. Medication is a tool, not a failure.",
                    bulletPoints: [
                        "Pre-departure cues should be randomized",
                        "Food puzzles extend calm engagement",
                        "Track improvement over 14-day windows"
                    ]
                )
            ]
        ),
        Guide(
            id: 10,
            title: "Feeding Rituals",
            subtitle: "Mealtime behaviour tells a story",
            icon: "fork.knife",
            species: nil,
            readMinutes: 5,
            sections: [
                Section(
                    id: 1,
                    heading: "Anticipation signals",
                    body: "Waiting at the bowl, vocalizing, or pacing before meals is learned routine — not always hunger. Consistent timing strengthens cues.",
                    bulletPoints: [
                        "Log signals 10 minutes before meals",
                        "Separate pets if guarding appears",
                        "Slow feeders reduce gulping stress in dogs"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Post-meal behaviour",
                    body: "Play bows after meals can mean joy; hiding can mean nausea. Birds may regurgitate — hormonal, not digestive.",
                    bulletPoints: [
                        "Note vomiting vs regurgitation carefully",
                        "Cat post-meal grooming is normal",
                        "Rabbit hay before pellets supports calm eating"
                    ]
                )
            ]
        ),
        Guide(
            id: 11,
            title: "Sleep & Rest Signals",
            subtitle: "Distinguish rest from shut-down",
            icon: "moon.zzz",
            species: nil,
            readMinutes: 5,
            sections: [
                Section(
                    id: 1,
                    heading: "Healthy rest",
                    body: "Loose muscles, easy arousal to gentle sounds, and varied postures indicate true rest. Frozen stiffness is not sleep.",
                    bulletPoints: [
                        "Dogs circle before lying — normal nesting",
                        "Cat loaf means alert relaxation",
                        "Bird one-foot sleep needs stable perch"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Sleep disruption",
                    body: "Night pacing, early waking screams, or refusal to flop in rabbits can track environmental changes. Log new furniture and schedule shifts.",
                    bulletPoints: [
                        "Keep sleep areas dark and cool",
                        "Reduce late-night high-arousal play",
                        "Compare weekend vs weekday rest logs"
                    ]
                )
            ]
        ),
        Guide(
            id: 12,
            title: "Building Your Dictionary",
            subtitle: "Turn logs into personal correlations",
            icon: "book.closed",
            species: nil,
            readMinutes: 6,
            sections: [
                Section(
                    id: 1,
                    heading: "Minimum viable data",
                    body: "Two occurrences of the same signal + context pair unlock a correlation. Consistency beats volume early on.",
                    bulletPoints: [
                        "Log within an hour for accurate context memory",
                        "Use notes for nuance — speed, direction, duration",
                        "Review patterns weekly, not daily"
                    ]
                ),
                Section(
                    id: 2,
                    heading: "Confidence interpretation",
                    body: "100% confidence with three matches is strong for that pet. Compare with species reference to see if your pet is typical or unique.",
                    bulletPoints: [
                        "Export correlations before vet visits",
                        "Share guides with family for consistent handling",
                        "Retire outdated patterns when behaviour changes"
                    ]
                )
            ]
        )
    ]

    static func guides(for species: PetSpecies?) -> [Guide] {
        guard let species else { return guides }
        return guides.filter { $0.species == nil || $0.species == species }
    }

    static func guide(for id: Int) -> Guide? {
        guides.first { $0.id == id }
    }
}
