import Foundation
import UIKit

enum PDFExporter {
    static func generate(
        logs: [BehaviourLog],
        pets: [Pet],
        correlations: [Correlation]
    ) -> Data {
        let text = ExportFormatter.textExport(logs: logs, pets: pets, correlations: correlations)
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { context in
            let margin: CGFloat = 48
            let lineHeight: CGFloat = 14
            let maxWidth = pageRect.width - margin * 2
            var y = margin

            func beginPageIfNeeded() {
                if y > pageRect.height - margin {
                    context.beginPage()
                    y = margin
                }
            }

            context.beginPage()

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 10, weight: .regular)
            ]

            let title = "tigersync Behaviour Export"
            title.draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
            y += 28

            for line in text.components(separatedBy: "\n") {
                beginPageIfNeeded()
                let attributed = NSAttributedString(string: line, attributes: bodyAttributes)
                let bounding = attributed.boundingRect(
                    with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )
                let drawHeight = max(lineHeight, ceil(bounding.height))
                beginPageIfNeeded()
                attributed.draw(
                    with: CGRect(x: margin, y: y, width: maxWidth, height: drawHeight),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )
                y += drawHeight + 4
            }
        }
    }

    static func writeTemporaryPDF(
        logs: [BehaviourLog],
        pets: [Pet],
        correlations: [Correlation]
    ) throws -> URL {
        let data = generate(logs: logs, pets: pets, correlations: correlations)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("tigersync-Export-\(Int(Date().timeIntervalSince1970)).pdf")
        try data.write(to: url, options: .atomic)
        return url
    }
}
