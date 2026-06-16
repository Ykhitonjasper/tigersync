import SwiftUI

public struct ExportLogsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var format: ExportFormat = .text
    @State private var exportText = ""
    @State private var pdfURL: URL?
    @State private var hapticTrigger = 0

    enum ExportFormat: String, CaseIterable {
        case text = "Text"
        case csv = "CSV"
        case pdf = "PDF"
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.sectionSpacing) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(
                        title: "Export format",
                        subtitle: "Share your journal as text, CSV, or PDF"
                    )

                    Picker("Format", selection: $format) {
                        ForEach(ExportFormat.allCases, id: \.self) { fmt in
                            Text(fmt.rawValue).tag(fmt)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("export.formatPicker")
                }
                .cardSurface(padding: 14)
                .padding(.horizontal, 16)

                if format == .pdf {
                    pdfPreview
                } else {
                    textPreview
                }

                shareButton
            }
            .padding(.top, 8)
            .screenChrome()
            .navigationTitle("Export Logs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("export.done")
                }
            }
            .task(id: appState.dataVersion) {
                await refreshExport()
            }
            .onChange(of: format) { _, _ in
                Task { await refreshExport() }
            }
            .hapticOnChange(of: hapticTrigger)
        }
        .tint(AppTheme.accent)
    }

    private var textPreview: some View {
        ScrollView {
            Text(exportText.isEmpty ? "Preparing export..." : exportText)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface(padding: 14)
                .padding(.horizontal, 16)
        }
        .accessibilityIdentifier("export.textPreview")
    }

    private var pdfPreview: some View {
        VStack(spacing: 14) {
            Image(systemName: "doc.richtext.fill")
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 72, height: 72)
                .background(AppTheme.accent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text("PDF ready to share")
                .font(.headline)
            Text("Includes logs and correlation summary")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .cardSurface(padding: 28)
        .padding(.horizontal, 16)
        .accessibilityIdentifier("export.pdfPreview")
    }

    @ViewBuilder
    private var shareButton: some View {
        if format == .pdf, let pdfURL {
            ShareLink(item: pdfURL) {
                Label("Share PDF", systemImage: "square.and.arrow.up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .padding(.horizontal, 16)
            .padding(.bottom)
            .accessibilityIdentifier("export.sharePDF")
            .simultaneousGesture(TapGesture().onEnded {
                hapticTrigger += 1
                HapticFeedback.success()
            })
        } else {
            ShareLink(item: exportText) {
                Label("Share Export", systemImage: "square.and.arrow.up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .padding(.horizontal, 16)
            .padding(.bottom)
            .accessibilityIdentifier("export.shareText")
            .simultaneousGesture(TapGesture().onEnded {
                hapticTrigger += 1
                HapticFeedback.success()
            })
        }
    }

    private func refreshExport() async {
        let logs = await appState.storage.loadLogs()
        let pets = await appState.storage.loadPets()
        let correlations = await appState.storage.loadAllCorrelations()

        switch format {
        case .text:
            exportText = ExportFormatter.textExport(logs: logs, pets: pets, correlations: correlations)
            pdfURL = nil
        case .csv:
            exportText = ExportFormatter.csvExport(logs: logs, pets: pets)
            pdfURL = nil
        case .pdf:
            exportText = ""
            pdfURL = try? PDFExporter.writeTemporaryPDF(logs: logs, pets: pets, correlations: correlations)
        }
    }
}

#Preview {
    ExportLogsSheet()
        .environmentObject(AppState())
}
