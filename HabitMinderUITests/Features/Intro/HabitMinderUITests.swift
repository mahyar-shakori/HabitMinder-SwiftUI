//
//  HabitMinderUITests.swift
//  HabitMinderUITests
//
//  Created by Mahyar on 29/06/2025.
//

import XCTest

final class HabitMinderUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }
    
    @MainActor
    func testIntroViewLoads() throws {
        let app = launchApp()
        
        XCTAssertTrue(app.images[AccessibilityIdentifier.IntroView.image].exists)
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifier.IntroView.title].exists)
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifier.IntroView.description].exists)
        XCTAssertTrue(app.buttons[AccessibilityIdentifier.IntroView.nextButton].exists)
        XCTAssertTrue(app.buttons[AccessibilityIdentifier.IntroView.skipButton].exists)
        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.IntroView.pageIndicatorPrimary].exists)
        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.IntroView.pageIndicatorSecondary].exists)
    }
    
    @MainActor
    func testNextButtonChangesState() throws {
        let app = launchApp()
        
        let imageBefore = app.images[AccessibilityIdentifier.IntroView.image].label
        let titleBefore = app.staticTexts[AccessibilityIdentifier.IntroView.title].label
        let descBefore = app.staticTexts[AccessibilityIdentifier.IntroView.description].label
        let secondaryDot = app.otherElements[AccessibilityIdentifier.IntroView.pageIndicatorSecondary]
        
        XCTAssertTrue(secondaryDot.exists)
        
        app.buttons[AccessibilityIdentifier.IntroView.nextButton].tap()
        
        XCTAssertFalse(secondaryDot.waitForExistence(timeout: 2))
        let imageAfter = app.images[AccessibilityIdentifier.IntroView.image].label
        let titleAfter = app.staticTexts[AccessibilityIdentifier.IntroView.title].label
        let descAfter = app.staticTexts[AccessibilityIdentifier.IntroView.description].label
        
        XCTAssertNotEqual(imageBefore, imageAfter)
        XCTAssertNotEqual(titleBefore, titleAfter)
        XCTAssertNotEqual(descBefore, descAfter)
    }
    
    @MainActor
    func testMultipleNextTapsEventuallyNavigatesToSetNameView() throws {
        let app = launchApp()
        
        let nextButton = app.buttons[AccessibilityIdentifier.IntroView.nextButton]
        nextButton.tap()
        nextButton.tap()
        
        let nameView = app.staticTexts[AccessibilityIdentifier.SetNameView.hiText]
        XCTAssertTrue(nameView.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testSkipButtonNavigatesToSetNameView() throws {
        let app = launchApp()
        
        let skipButton = app.buttons[AccessibilityIdentifier.IntroView.skipButton]
        skipButton.tap()
        
        let nameView = app.staticTexts[AccessibilityIdentifier.SetNameView.hiText]
        XCTAssertTrue(nameView.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testSkipButtonIsHiddenAfterFirstNextTap() throws {
        let app = launchApp()
        
        let skipButton = app.buttons[AccessibilityIdentifier.IntroView.skipButton]
        app.buttons[AccessibilityIdentifier.IntroView.nextButton].tap()
        
        XCTAssertFalse(skipButton.waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
