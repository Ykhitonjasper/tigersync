import SwiftUI

public struct SettingsScreen: View {
    @EnvironmentObject private var appState: AppState
    @State private var isShowingExport = false
    @State private var isShowingDeleteConfirm = false
    @State private var logCount = 0
    @State private var petCount = 0
    @State private var deleteHapticTrigger = 0

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                aboutSection
                dataSection
                legalSection
                referenceSection
            }
            .padding(16)
        }
        .screenChrome()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isShowingExport) {
            ExportLogsSheet()
        }
        .confirmationDialog(
            "Delete all data?",
            isPresented: $isShowingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete All Data", role: .destructive) {
                deleteHapticTrigger += 1
                HapticFeedback.mediumImpact()
                Task {
                    await appState.storage.clearAllData()
                    appState.notifyDataChanged()
                    await refreshCounts()
                    HapticFeedback.success()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently removes all pets and behaviour logs from your device. Reference guides are not affected. This cannot be undone.")
        }
        .sensoryFeedback(.warning, trigger: deleteHapticTrigger)
        .task(id: appState.dataVersion) {
            await refreshCounts()
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "About", subtitle: "App information and purpose")

            VStack(alignment: .leading, spacing: 12) {
                settingsRow(label: "App", value: AppInfo.displayName)
                settingsRow(label: "Version", value: AppInfo.versionString)

                Divider()

                Text(LegalContent.appPurpose)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Not a substitute for professional veterinary advice. Always consult a qualified veterinarian for health concerns.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("All journal data is stored locally on your device.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .cardSurface(padding: 14)
        }
    }

    // MARK: - Data

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Your Data", subtitle: "Journal storage on this device")

            VStack(spacing: 0) {
                settingsRow(label: "Behaviour logs", value: "\(logCount)")
                Divider().padding(.leading, 14)
                settingsRow(label: "Pets", value: "\(petCount)")
            }
            .cardSurface(padding: 0)

            VStack(spacing: 10) {
                settingsButton("Export Logs", icon: "square.and.arrow.up") {
                    isShowingExport = true
                }
                .accessibilityIdentifier("settings.export")

                settingsButton("Load Sample Data", icon: "tray.and.arrow.down") {
                    Task {
                        await appState.storage.loadSampleData()
                        appState.notifyDataChanged()
                        await refreshCounts()
                        HapticFeedback.success()
                    }
                }

                settingsButton("Delete All Data", icon: "trash", tint: .red) {
                    isShowingDeleteConfirm = true
                }
                .accessibilityIdentifier("settings.deleteAllData")
            }
        }
    }

    // MARK: - Legal

    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Legal", subtitle: "In-app documents")

            VStack(spacing: 0) {
                NavigationLink {
                    LegalDocumentScreen(title: "Privacy Policy", bodyText: LegalContent.privacyPolicy)
                } label: {
                    legalRowLabel(title: "Privacy Policy", icon: "hand.raised")
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("settings.privacyPolicy")

                Divider().padding(.leading, 14)

                NavigationLink {
                    LegalDocumentScreen(title: "Terms of Service", bodyText: LegalContent.termsOfService)
                } label: {
                    legalRowLabel(title: "Terms of Service", icon: "doc.text")
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("settings.termsOfService")
            }
            .cardSurface(padding: 0)
        }
    }

    // MARK: - Reference

    private var referenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Reference", subtitle: "Built-in guides and tools")

            VStack(spacing: 0) {
                settingsRow(label: "Species patterns", value: "\(SpeciesReferenceData.allPatterns.count)")
                Divider().padding(.leading, 14)
                settingsRow(label: "Behaviour guides", value: "\(BehaviourGuidesData.guides.count)")
            }
            .cardSurface(padding: 0)

            VStack(spacing: 10) {
                NavigationLink(destination: SpeciesReferenceScreen()) {
                    settingsLinkLabel("Species Reference", icon: "leaf.arrow.triangle.circlepath")
                }
                .buttonStyle(.plain)

                NavigationLink(destination: WeeklyInsightsScreen()) {
                    settingsLinkLabel("Weekly Insights", icon: "chart.bar.doc.horizontal")
                }
                .buttonStyle(.plain)

                NavigationLink(destination: StressScoreScreen()) {
                    settingsLinkLabel("Stress Score", icon: "heart.text.clipboard")
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Helpers

    private func settingsRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
    }

    private func settingsButton(_ title: String, icon: String, tint: Color = AppTheme.accent, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint == .red ? .red : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface(padding: 14)
        }
        .buttonStyle(.plain)
    }

    private func settingsLinkLabel(_ title: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .cardSurface(padding: 14)
    }

    private func legalRowLabel(title: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
    }

    private func refreshCounts() async {
        logCount = await appState.storage.loadLogs().count
        petCount = await appState.storage.loadPets().count
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .environmentObject(AppState())
            .tint(AppTheme.accent)
    }
}
