//
//  Snapshots.swift
//  OpenSleepSounds
//
//  Created by Jack Hamilton on 2/10/24.
//

import XCTest

// Used for fastlane appstore-connect snapshots
final class OpenSleepSoundsUITests: XCTestCase {

    @MainActor override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    @MainActor func generateScreenshots() {
        let app = XCUIApplication()
        snapshot("00-Home")
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        let lightRainElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Light Rain")
        lightRainElementsQuery.children(matching: .button).matching(identifier: "Go Down").element(boundBy: 0).tap()
        lightRainElementsQuery.children(matching: .button).matching(identifier: "Play").element(boundBy: 0).tap()
        snapshot("01-MainScreen")
        
        scrollViewsQuery.otherElements.buttons["Stop"].tap()
        let clockButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Gear"]
        clockButton.tap()
        snapshot("02-Timer")
    }
}

