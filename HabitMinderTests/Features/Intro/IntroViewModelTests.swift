//
//  IntroViewModelTests.swift
//  HabitMinder
//
//  Created by Mahyar on 02/07/2025.
//

import XCTest
@testable import HabitMinder

final class IntroViewModelTests: XCTestCase {
    
    func testInitialStateIsFirst() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        
        // Act
        let currentState = viewModel.currentState
        
        // Assert
        XCTAssertEqual(currentState, .first)
    }
    
    func testNextStateFromFirstToSecond() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        
        // Act
        viewModel.nextState()
        
        // Assert
        XCTAssertEqual(viewModel.currentState, .second)
    }
    
    func testNextStateCallsCoordinatorWhenSecond() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        viewModel.nextState() // from .first to .second
        
        // Act
        viewModel.nextState() // should call coordinator
        
        // Assert
        XCTAssertTrue(coordinator.didNavigate)
    }

    func testGoToSetNameCallsCoordinatorDirectly() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        
        // Act
        viewModel.goToSetNamePage()
        
        // Assert
        XCTAssertTrue(coordinator.didNavigate)
    }
}
