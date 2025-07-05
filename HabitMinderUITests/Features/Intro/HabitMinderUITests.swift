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
    
    private lazy var app: XCUIApplication = {
        let app = XCUIApplication()
        app.launch()
        return app
    }()
    
    private var nextButton: XCUIElement {
        app.buttons[AccessibilityIdentifier.IntroView.nextButton]
    }
    
    private var skipButton: XCUIElement {
        app.buttons[AccessibilityIdentifier.IntroView.skipButton]
    }
    
    private var image: XCUIElement {
        app.images[AccessibilityIdentifier.IntroView.image]
    }
    
    private var titleText: XCUIElement {
        app.staticTexts[AccessibilityIdentifier.IntroView.title]
    }
    
    private var descText: XCUIElement {
        app.staticTexts[AccessibilityIdentifier.IntroView.description]
    }
    
    private var primaryDot: XCUIElement {
        app.otherElements[AccessibilityIdentifier.IntroView.pageIndicatorPrimary]
    }
    
    private var secondaryDot: XCUIElement {
        app.otherElements[AccessibilityIdentifier.IntroView.pageIndicatorSecondary]
    }
   
    @MainActor
    func testIntroViewLoads() throws {
        // Assert
        XCTAssertTrue(image.exists)
        XCTAssertTrue(titleText.exists)
        XCTAssertTrue(descText.exists)
        XCTAssertTrue(nextButton.exists)
        XCTAssertTrue(skipButton.exists)
        XCTAssertTrue(primaryDot.exists)
        XCTAssertTrue(secondaryDot.exists)
    }
    
    @MainActor
    func testNextButtonChangesState() throws {
        // Arrange
        let imageBefore = image.label
        let titleBefore = titleText.label
        let descBefore = descText.label
        
        XCTAssertTrue(secondaryDot.exists)
        
        // Act
        nextButton.tap()
        
        // Assert
        XCTAssertFalse(secondaryDot.waitForExistence(timeout: 1))
        XCTAssertNotEqual(imageBefore, image.label)
        XCTAssertNotEqual(titleBefore, titleText.label)
        XCTAssertNotEqual(descBefore, descText.label)
    }
   
    @MainActor
    func testSkipButtonIsHiddenAfterFirstNextTap() throws {
        // Act
        nextButton.tap()
        
        // Assert
        XCTAssertFalse(skipButton.waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
