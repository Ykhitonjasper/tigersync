import SwiftUI

public struct LogEntryScreen: View {
    @EnvironmentObject private var appState: AppState

    public let onSave: (
        _ signals: [Signal],
        _ contexts: [ContextTag],
        _ petId: Int,
        _ note: String,
        _ timestamp: Date
    ) async -> Void

    public init(
        onSave: @escaping (
            _ signals: [Signal],
            _ contexts: [ContextTag],
            _ petId: Int,
            _ note: String,
            _ timestamp: Date
        ) async -> Void
    ) {
        self.onSave = onSave
    }

    public var body: some View {
        LogEntryContent(appState: appState, onSave: onSave)
    }
}

private struct LogEntryContent: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LogEntryViewModel
    @State private var hapticTrigger = 0
    let onSave: (
        _ signals: [Signal],
        _ contexts: [ContextTag],
        _ petId: Int,
        _ note: String,
        _ timestamp: Date
    ) async -> Void

    init(
        appState: AppState,
        onSave: @escaping (
            _ signals: [Signal],
            _ contexts: [ContextTag],
            _ petId: Int,
            _ note: String,
            _ timestamp: Date
        ) async -> Void
    ) {
        _viewModel = StateObject(wrappedValue: LogEntryViewModel(appState: appState))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.pets.isEmpty {
                    EmptyStateView(
                        icon: "pawprint",
                        title: "No pets yet",
                        subtitle: "Add a pet before logging behaviour moments."
                    )
                    .padding()
                } else {
                    logForm
                }
            }
            .screenChrome()
            .navigationTitle("Log Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                if !viewModel.pets.isEmpty {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            hapticTrigger += 1
                            HapticFeedback.success()
                            Task {
                                guard let petId = viewModel.selectedPetId else { return }
                                await onSave(
                                    viewModel.selectedSignals,
                                    viewModel.selectedContexts,
                                    petId,
                                    viewModel.note,
                                    viewModel.timestamp
                                )
                                dismiss()
                            }
                        }
                        .disabled(!viewModel.canSave)
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("log.save")
                        .sensoryFeedback(.success, trigger: hapticTrigger)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingSignalPicker) {
                SignalPickerScreen(
                    allSignals: viewModel.allSignals,
                    selected: $viewModel.selectedSignals
                )
            }
            .sheet(isPresented: $viewModel.isShowingContextPicker) {
                ContextPickerScreen(
                    allTags: viewModel.allContexts,
                    selected: $viewModel.selectedContexts
                )
            }
            .task {
                await viewModel.load()
            }
        }
        .tint(AppTheme.accent)
    }

    private var logForm: some View {
        ScrollView {
            VStack(spacing: AppTheme.sectionSpacing) {
                pickerSection(
                    title: "Pet",
                    subtitle: "Who is this moment about?"
                ) {
                    Picker("Pet", selection: Binding(
                        get: { viewModel.selectedPetId ?? viewModel.pets.first?.id ?? 0 },
                        set: { viewModel.selectedPetId = $0 }
                    )) {
                        ForEach(viewModel.pets) { pet in
                            Label(pet.name, systemImage: pet.species.icon).tag(pet.id)
                        }
                    }
                    .pickerStyle(.menu)
                }

                pickerSection(
                    title: "Behaviour Signals",
                    subtitle: "What did you observe?"
                ) {
                    selectionRow(
                        isEmpty: viewModel.selectedSignals.isEmpty,
                        emptyLabel: "Select signals",
                        editAction: { viewModel.isShowingSignalPicker = true }
                    ) {
                        FlowLayout(spacing: 8) {
                            ForEach(viewModel.selectedSignals) { signal in
                                SignalChip(signal: signal, isSelected: true)
                            }
                        }
                    }
                }

                pickerSection(
                    title: "Context",
                    subtitle: "What was happening around them?"
                ) {
                    selectionRow(
                        isEmpty: viewModel.selectedContexts.isEmpty,
                        emptyLabel: "Select context",
                        editAction: { viewModel.isShowingContextPicker = true }
                    ) {
                        FlowLayout(spacing: 8) {
                            ForEach(viewModel.selectedContexts) { tag in
                                ContextChip(tag: tag, isSelected: true)
                            }
                        }
                    }
                }

                pickerSection(title: "When", subtitle: "Time of the observation") {
                    DatePicker("Timestamp", selection: $viewModel.timestamp)
                        .datePickerStyle(.compact)
                }

                pickerSection(title: "Note", subtitle: "Optional details") {
                    TextField("What happened?", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .padding(16)
        }
    }

    private func pickerSection<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title, subtitle: subtitle)
            VStack(alignment: .leading, spacing: 12) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(padding: 14)
        }
    }

    @ViewBuilder
    private func selectionRow<Content: View>(
        isEmpty: Bool,
        emptyLabel: String,
        editAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if isEmpty {
            Button(emptyLabel, systemImage: "plus.circle") {
                editAction()
            }
            .font(.subheadline.weight(.semibold))
        } else {
            VStack(alignment: .leading, spacing: 10) {
                content()
                Button("Edit selection", systemImage: "pencil") {
                    editAction()
                }
                .font(.caption.weight(.semibold))
            }
        }
    }
}

#Preview {
    LogEntryScreen { _, _, _, _, _ in }
        .environmentObject(AppState())
}
