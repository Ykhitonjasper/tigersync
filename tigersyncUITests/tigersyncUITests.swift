import XCTest

final class TigersyncUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testJournalShowsAfterLaunch() throws {
        let app = launchApp(fresh: true)

        XCTAssertTrue(app.navigationBars["Journal"].waitForExistence(timeout: 10))

        let loadSample = app.buttons["Load Sample Data"]
        if loadSample.waitForExistence(timeout: 3) {
            loadSample.tap()
        }

        let fab = app.buttons["journal.fab"]
        XCTAssertTrue(fab.waitForExistence(timeout: 10))
    }

    @MainActor
    func testTabNavigation() throws {
        let app = launchApp()

        app.tabBars.buttons["Learn"].tap()
        XCTAssertTrue(app.navigationBars["Learn"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Pets"].tap()
        XCTAssertTrue(app.navigationBars["Pets"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testExportSheetOpens() throws {
        let app = launchApp(fresh: true)

        if app.buttons["Load Sample Data"].waitForExistence(timeout: 3) {
            app.buttons["Load Sample Data"].tap()
        }

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))

        let exportCell = app.staticTexts["Export Logs"]
        XCTAssertTrue(exportCell.waitForExistence(timeout: 5))
        exportCell.tap()

        XCTAssertTrue(app.navigationBars["Export Logs"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testAddPetFlow() throws {
        let app = launchApp(fresh: true)

        app.tabBars.buttons["Pets"].tap()

        let addPet = app.buttons["Add Pet"].firstMatch
        XCTAssertTrue(addPet.waitForExistence(timeout: 8))
        addPet.tap()

        let nameField = app.textFields["pet.nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("UI Test Pet")

        app.buttons["pet.save"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Pet"].waitForExistence(timeout: 8))
    }

    // MARK: - Helpers

    @MainActor
    private func launchApp(fresh: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("UI-Testing")
        if fresh { app.launchArguments.append("UI-Fresh") }
        app.launch()
        if fresh {
            sleep(2)
        }
        return app
    }
}
