import XCTest

class SwiftUIToDoUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    app = XCUIApplication()
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testInitialUI() throws {
    app.launch()

    var buttons = app.buttons
    XCTAssertTrue(buttons["Edit"].exists)
    XCTAssertTrue(buttons["Add New"].exists)

    buttons["Edit"].tap()

    XCTAssertTrue(buttons["Done"].exists)

    XCTAssertTrue(findButtonBy(label: "Delete ").exists)
    XCTAssertTrue(findButtonBy(label: "Reorder").exists)

    buttons["Done"].tap()

    buttons = app.buttons

    XCTAssertFalse(buttons["Done"].exists)
    XCTAssertFalse(findButtonBy(label: "Delete ").exists)
    XCTAssertFalse(findButtonBy(label: "Reorder").exists)
  }

  private func findButtonBy(label: String) -> XCUIElement {
    app.buttons.element(matching: NSPredicate(format: "label = '\(label)'"))
  }
}
