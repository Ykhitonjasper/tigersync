import Foundation

enum SignalLibraryData {
    struct Entry: Identifiable {
        let id: Int
        let name: String
        let category: SignalCategory
        let icon: String
        let summary: String
        let watchFor: String
        let speciesNotes: [PetSpecies: String]
    }

    static let entries: [Entry] = [
        Entry(id: 1, name: "Wagging", category: .tail, icon: "arrow.left.and.right", summary: "Rhythmic tail movement expressing arousal — positive or negative.", watchFor: "Speed, height, and stiffness change meaning.", speciesNotes: [
            .dog: "Loose mid wag is often friendly; stiff high wag needs caution.",
            .cat: "Tail lash or twitch usually means irritation, not joy.",
            .bird: "Some species wag tail side-to-side when excited.",
            .rabbit: "Rare; focus on thumping instead."
        ]),
        Entry(id: 2, name: "Tucked", category: .tail, icon: "arrow.down.to.line", summary: "Tail held low or between legs.", watchFor: "Often fear, pain, or submission.", speciesNotes: [
            .dog: "Common fear signal — pair with ears and posture.",
            .cat: "Tucked tail with crouch indicates withdrawal.",
            .bird: "Less relevant; watch wing position.",
            .rabbit: "May freeze with ears back simultaneously."
        ]),
        Entry(id: 3, name: "Upright", category: .tail, icon: "arrow.up", summary: "Tail raised above spine level.", watchFor: "Confidence or tension depending on rigidity.", speciesNotes: [
            .dog: "High stiff tail can mean alertness toward triggers.",
            .cat: "Straight up with quiver is friendly greeting.",
            .bird: "Fanning tail may be display or balance.",
            .rabbit: "Less expressive; note ear angle instead."
        ]),
        Entry(id: 4, name: "Slow Sway", category: .tail, icon: "arrow.trianglehead.2.clockwise.rotate.90", summary: "Gentle side-to-side tail movement.", watchFor: "Cats use this before irritation escalates.", speciesNotes: [
            .dog: "Can appear during uncertain sniffing.",
            .cat: "Stop petting when sway begins.",
            .bird: "Occasional balance adjustment.",
            .rabbit: "Uncommon — log if seen with tension."
        ]),
        Entry(id: 5, name: "Perked", category: .ears, icon: "ear", summary: "Ears forward and alert.", watchFor: "Interest, curiosity, or pre-reaction state.", speciesNotes: [
            .dog: "Forward ears with loose body = curiosity.",
            .cat: "Forward ears with hunting crouch = play predation.",
            .bird: "N/A — use eye pinning and posture.",
            .rabbit: "Forward ears with freeze = listening mode."
        ]),
        Entry(id: 6, name: "Pinned", category: .ears, icon: "chevron.down", summary: "Ears flattened against head.", watchFor: "Fear, appeasement, or aggression prep.", speciesNotes: [
            .dog: "Common at vet or during scolding.",
            .cat: "Flat ears + hiss = give space.",
            .bird: "N/A",
            .rabbit: "Pinned during handling = stop lifting."
        ]),
        Entry(id: 7, name: "Swiveling", category: .ears, icon: "arrow.clockwise", summary: "Independent ear rotation toward sounds.", watchFor: "Environmental scanning — note sound source.", speciesNotes: [
            .dog: "Shows engagement with environment.",
            .cat: "Radar mode before deciding fight/flight.",
            .bird: "N/A",
            .rabbit: "One ear forward, one back = threat assessment."
        ]),
        Entry(id: 8, name: "Relaxed", category: .ears, icon: "minus.circle", summary: "Neutral ear carriage for species.", watchFor: "Baseline for comparison in your logs.", speciesNotes: [
            .dog: "Soft eyes often accompany relaxed ears.",
            .cat: "Slight outward rotation at rest.",
            .bird: "N/A",
            .rabbit: "Soft eyes + loaf posture = calm."
        ]),
        Entry(id: 9, name: "Barking", category: .vocal, icon: "speaker.wave.2.fill", summary: "Sharp canine vocalization.", watchFor: "Pitch and repetition distinguish alarm vs play.", speciesNotes: [
            .dog: "High rapid barks often alert; single deep bark warning.",
            .cat: "N/A — use meow/trill categories.",
            .bird: "N/A",
            .rabbit: "N/A — thumping is primary alert."
        ]),
        Entry(id: 10, name: "Purring", category: .vocal, icon: "waveform", summary: "Continuous low vibration sound.", watchFor: "Cats also purr when stressed — read body.", speciesNotes: [
            .dog: "N/A",
            .cat: "Soft body = content; tense body = self-soothing.",
            .bird: "N/A",
            .rabbit: "Quiet tooth grinding = contentment."
        ]),
        Entry(id: 11, name: "Whining", category: .vocal, icon: "exclamationmark.bubble", summary: "High vocalization seeking attention or relief.", watchFor: "Context separates anxiety from anticipation.", speciesNotes: [
            .dog: "Common before walks or during separation.",
            .cat: "Less common — may signal pain.",
            .bird: "N/A",
            .rabbit: "Honking overlaps with excitement."
        ]),
        Entry(id: 12, name: "Chirping", category: .vocal, icon: "bird.fill", summary: "Short bird vocalizations.", watchFor: "Contact calls vs alarm screams differ in volume.", speciesNotes: [
            .dog: "N/A",
            .cat: "Chattering at birds is predatory frustration.",
            .bird: "Soft chirps = flock contact; screams = distress.",
            .rabbit: "N/A"
        ]),
        Entry(id: 13, name: "Crouched", category: .posture, icon: "figure.fall", summary: "Low body position close to ground.", watchFor: "Fear crouch vs hunting crouch differ in tension.", speciesNotes: [
            .dog: "May precede submissive urination.",
            .cat: "Hunting crouch has focused stare.",
            .bird: "Flattening body = fear.",
            .rabbit: "Freeze before bolt."
        ]),
        Entry(id: 14, name: "Stretched", category: .posture, icon: "figure.walk", summary: "Full body extension.", watchFor: "Post-nap stretch vs tense stretch.", speciesNotes: [
            .dog: "Play bow resembles stretch — check tail.",
            .cat: "After sleep — relaxed.",
            .bird: "Wing stretch needs space.",
            .rabbit: "Long stretch after flop recovery."
        ]),
        Entry(id: 15, name: "Bowing", category: .posture, icon: "figure.play", summary: "Front low, rear elevated.", watchFor: "Classic canine play invitation.", speciesNotes: [
            .dog: "Meta-signal for play — reward it.",
            .cat: "Rare — distinguish from pounce prep.",
            .bird: "N/A",
            .rabbit: "N/A"
        ]),
        Entry(id: 16, name: "Curled Up", category: .posture, icon: "moon.zzz", summary: "Compact resting posture.", watchFor: "Cold, sleep, or guarded rest.", speciesNotes: [
            .dog: "Tight curl may mean cold or anxiety.",
            .cat: "Paw-over-face = deep trust.",
            .bird: "Fluffed on one foot = rest.",
            .rabbit: "Loaf vs tight ball shows comfort level."
        ])
    ]

    static func entry(for signalId: Int) -> Entry? {
        entries.first { $0.id == signalId }
    }

    static func entries(in category: SignalCategory) -> [Entry] {
        entries.filter { $0.category == category }
    }
}
