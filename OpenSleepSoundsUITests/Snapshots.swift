//
//  Snapshots.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 2/10/24.
//

import XCTest

final class OpenSleepSoundsUITests: XCTestCase {

    @MainActor override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    @MainActor func testGenerateScreenshots() {
        let app = XCUIApplication()
        snapshot("00-Home")
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Go Down"].tap()
        
        let playButton = elementsQuery.buttons["Play"]
        playButton.tap()
        snapshot("01-MainScreen")
        
        let stopButton = elementsQuery.buttons["Stop"]
        stopButton.tap()
        
        let clockButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Clock"]/*[[".otherElements[\"Clock\"].buttons[\"Clock\"]",".buttons[\"Clock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        clockButton.tap()
        snapshot("02-Timer")
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

