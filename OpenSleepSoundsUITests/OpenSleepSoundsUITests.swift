//
//  OpenSleepSoundsUITests.swift
//  OpenSleepSoundsUITests
//
//  Created by Jack Hamilton on 1/24/24.
//

import XCTest

final class OpenSleepSoundsUITests: XCTestCase {

    @MainActor override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testBasicUI() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Go Down"].tap()
        elementsQuery.sliders["100%"].swipeLeft()
        XCTAssert(app.staticTexts["2%"].exists)
        
        let playButton = elementsQuery.buttons["Play"]
        playButton.tap()
        XCTAssert(app.staticTexts["01:00:00"].exists)
        
        let stopButton = elementsQuery.buttons["Stop"]
        stopButton.tap()
        XCTAssert(!app.staticTexts["01:00:00"].exists)
        
        let clockButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Clock"]/*[[".otherElements[\"Clock\"].buttons[\"Clock\"]",".buttons[\"Clock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        clockButton.tap()
        XCTAssert(app.buttons["Confirm"].exists)
        
        let datePickersQuery = app.datePickers
        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["01 o’clock"]/*[[".pickers.pickerWheels[\"01 o’clock\"]",".pickerWheels[\"01 o’clock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["00 minutes"]/*[[".pickers.pickerWheels[\"00 minutes\"]",".pickerWheels[\"00 minutes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.buttons["Confirm"].tap()
        XCTAssert(!app.buttons["Confirm"].exists)
        
        playButton.tap()
        XCTAssert(app.staticTexts["22:21:00"].exists)
        stopButton.tap()
        XCTAssert(!app.staticTexts["22:21:00"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
                        measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
