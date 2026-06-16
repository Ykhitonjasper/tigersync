import Foundation

enum LegalContent {
    static let appPurpose = """
    tigersync is a personal pet behaviour journal. Log signals, contexts, and notes to build a behaviour dictionary for each pet. Discover patterns from your own observations, explore species reference guides, and export your journal — all on your device.
    """

    static let privacyPolicy = """
    tigersync stores your pet behaviour journal locally on your device. We do not collect, transmit, or sell your journal data.

    Data stored on device:
    • Pet profiles and behaviour log entries
    • Notes, signals, and context tags you record

    Network use:
    • The app may use Firebase Remote Config to read configuration settings
    • If enabled, analytics endpoints may receive device model, OS version, app version, locale, and session metadata — not your journal contents

    Your rights:
    • Delete all journal data anytime in Settings
    • Uninstalling the app removes local data

    Contact: For privacy questions, use the support email listed in the App Store.

    Last updated: June 2026
    """

    static let termsOfService = """
    By using tigersync you agree to these terms.

    Purpose:
    tigersync is an educational behaviour journal tool. It is not veterinary advice, diagnosis, or treatment.

    Your responsibility:
    • You are responsible for the accuracy of logs you create
    • Consult a qualified veterinarian for health concerns
    • You must comply with applicable laws when using the app

    Limitation of liability:
    tigersync is provided "as is" without warranties. We are not liable for decisions made based on journal entries or reference content.

    Changes:
    We may update these terms. Continued use after updates constitutes acceptance.

    Last updated: June 2026
    """
}
