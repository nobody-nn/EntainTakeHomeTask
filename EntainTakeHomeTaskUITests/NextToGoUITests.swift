//
//  NextToGoUITests.swift
//  EntainTakeHomeTaskUITests
//
//  Created by nana Zhang on 2024/3/13.
//

import XCTest

final class NextToGoSuccessUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = true
        
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-next-to-go-network-success":"1"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    /// races
    func test_race_list_with_first_five_are_valid() {
        // let allElements = app.descendants(matching: .any)
        
        let cells = app.cells
        XCTAssertEqual(cells.count, 5, "There should be 5 races on the screen")
        
        /// Expired item DO Not exist
        // 199f70aa-7b8f-4085-8071-4540433eb058
        XCTAssertFalse(app.staticTexts["Happy Valley"].exists)
        XCTAssertFalse(app.staticTexts["Ap Lei Chau Hcp (C5)"].exists)
        
        /// Items should exist
        // 85515602-bf46-49e3-a3ff-f64ea0df2434
        XCTAssertTrue(app.staticTexts["Cannington"].exists)
        XCTAssertTrue(app.staticTexts["Free Entry Tabtouch Park"].exists)
        
        // e55917bc-cb33-4fca-acef-c54331fed121
        XCTAssertTrue(app.staticTexts["Bendigo"].exists)
        XCTAssertTrue(app.staticTexts["Vhrc - Cgi Pace"].exists)
        // 8cb76e18-8fd0-49ff-80d7-17eb2f212623
        XCTAssertTrue(app.staticTexts["Kolkata"].exists)
        XCTAssertTrue(app.staticTexts["Governor Handicap"].exists)
        // 2f536404-8693-4198-9a2e-1f1b24771102
        XCTAssertTrue(app.staticTexts["Monmore Bags"].exists)
        XCTAssertTrue(app.staticTexts["Race 1"].exists)
        // 9c18b068-c7f3-45cd-aec5-82408e5f72ca
        XCTAssertTrue(app.staticTexts["Richmond"].exists)
        XCTAssertTrue(app.staticTexts["Buy Wick Coffee At Wickcoffee.Com"].exists)
        
        // Tabbar
        XCTAssertTrue(app.buttons["Next"].exists)
        XCTAssertTrue(app.buttons["Next"].isSelected)
        XCTAssertTrue(app.buttons["Setting"].exists)
        app.buttons["Setting"].tap()
        XCTAssertTrue(app.buttons["Setting"].isSelected)
        
        app.buttons["Next"].tap()
        XCTAssertTrue(app.buttons["Next"].isSelected)
    }
    
    /// buttons
    func test_buttons_are_valid() {
        let filterButton = app.buttons["filter_button"]
        XCTAssertTrue(filterButton.isEnabled)
        XCTAssertTrue(filterButton.isEnabled)
        
        let refreshButton = app.buttons["refresh_button"]
        XCTAssertTrue(refreshButton.isEnabled)
        XCTAssertTrue(refreshButton.isEnabled)
        
        filterButton.tap()
        // FilterView should show up
        XCTAssertTrue(app.buttons["Submit"].isEnabled)
        XCTAssertTrue(app.buttons["Reset"].isEnabled)
        XCTAssertTrue(app.buttons["Close"].isEnabled)
        
        // categories
        let predicate = NSPredicate(format: "identifier CONTAINS 'category_'")
        let categoryButtons = app.buttons.containing(predicate)
        
        XCTAssertEqual(categoryButtons.count, 3, "There should be 3 categories")
        XCTAssertTrue(app.buttons["category_Greyhound"].exists)
        XCTAssertTrue(app.buttons["category_Harness"].exists)
        XCTAssertTrue(app.buttons["category_Horse"].exists)
        
        app.buttons["Close"].tap()
        XCTAssertFalse(app.buttons["Submit"].exists)
        XCTAssertFalse(app.buttons["Reset"].exists)
        XCTAssertFalse(app.buttons["Close"].exists)
        
    }
}
