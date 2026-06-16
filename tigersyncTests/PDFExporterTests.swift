import Foundation
import Testing
@testable import tigersync

@Suite("PDFExporter")
struct PDFExporterTests {
    @Test("generates non-empty PDF data")
    func generatesPDF() {
        let pet = Pet(id: 1, name: "Buddy", species: .dog, breed: "Mix", colorHex: "#F4A460")
        let log = BehaviourLog(id: 1, petId: 1, signalIds: [1], contextTagIds: [2], timestamp: Date(), note: "Test")
        let data = PDFExporter.generate(logs: [log], pets: [pet], correlations: [])

        #expect(!data.isEmpty)
        #expect(String(data: data.prefix(4), encoding: .ascii) == "%PDF")
    }
}
