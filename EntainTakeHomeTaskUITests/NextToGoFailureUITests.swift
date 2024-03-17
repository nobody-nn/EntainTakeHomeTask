//
//  NextToGoFailureUITests.swift
//  EntainTakeHomeTaskUITests
//
//  Created by nana Zhang on 2024/3/16.
//

import XCTest

final class NextToGoFailureUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = true
        
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-next-to-go-network-success":"0", "-next-to-go-fail_status":"401"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func test_empty_ui_elements_is_exist() {
        XCTAssertTrue(app.images.firstMatch.exists)
        
        let retryButton = app.buttons["retry_button"]
        XCTAssertTrue(retryButton.exists)
        XCTAssertTrue(retryButton.isEnabled)
        
        // filter DISABLED
        let filterButton = app.buttons["filter_button"]
        XCTAssertTrue(filterButton.exists)
        XCTAssertFalse(filterButton.isEnabled)
        
        let refreshButton = app.buttons["refresh_button"]
        XCTAssertTrue(refreshButton.isEnabled)
        XCTAssertTrue(refreshButton.isEnabled)
        
        XCTAssertTrue(app.staticTexts["Unauthorized request"].exists)
    }
    
}
