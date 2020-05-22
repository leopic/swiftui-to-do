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
    XCTAssertTrue(buttons["btnToggle"].exists)
    XCTAssertTrue(buttons["Edit"].exists)
    XCTAssertTrue(buttons["Add Item"].exists)
    XCTAssertTrue(buttons["Item Status"].exists)

    buttons["Edit"].tap()

    XCTAssertTrue(buttons["Done"].exists)
    XCTAssertTrue(buttons["Delete"].exists)
    XCTAssertTrue(buttons["Reorder"].exists)

    buttons = app.buttons

    XCTAssertFalse(buttons["Done"].exists)
    XCTAssertFalse(buttons["Delete"].exists)
    XCTAssertFalse(buttons["Reorder"].exists)
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
        XCUIApplication().launch()
      }
    }
  }
}
