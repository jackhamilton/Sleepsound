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
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        let lightRainElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Light Rain")
        lightRainElementsQuery.children(matching: .button).matching(identifier: "Go Down").element(boundBy: 0).tap()
        lightRainElementsQuery.children(matching: .button).matching(identifier: "Play").element(boundBy: 0).tap()
        snapshot("01-MainScreen")
        
        scrollViewsQuery.otherElements.buttons["Stop"].tap()
        let clockButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Clock"]/*[[".otherElements[\"Clock\"].buttons[\"Clock\"]",".buttons[\"Clock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        clockButton.tap()
        snapshot("02-Timer")
    }
}

