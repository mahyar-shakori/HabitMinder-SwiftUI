//
//  IntroViewIntegrationTests.swift
//  HabitMinder
//
//  Created by Mahyar on 02/07/2025.
//

import SwiftUI
import Testing
@testable import HabitMinder

@Suite
struct IntroViewIntegrationTests {

    @MainActor
    @Test("tapping next twice should navigate to set name page")
    func test_tapNextTwiceTriggersCoordinator() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        let view = IntroView(introViewModel: viewModel)
            .environmentObject(ThemeManager.previewInstance)

        let hosting = UIHostingController(rootView: view)
        let window = UIWindow()
        window.rootViewController = hosting
        window.makeKeyAndVisible()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.2))

        // Act
        viewModel.nextState()
        viewModel.nextState()

        // Assert
        #expect(coordinator.didNavigate)
    }

    @MainActor
    @Test("tapping skip should trigger coordinator immediately")
    func test_tapSkipTriggersCoordinator() {
        // Arrange
        let coordinator = MockIntroCoordinator()
        let viewModel = IntroViewModel(coordinator: coordinator)
        let view = IntroView(introViewModel: viewModel)
            .environmentObject(ThemeManager.previewInstance)

        let hosting = UIHostingController(rootView: view)
        let window = UIWindow()
        window.rootViewController = hosting
        window.makeKeyAndVisible()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.2))

        // Act
        viewModel.goToSetNamePage()

        // Assert
        #expect(coordinator.didNavigate)
    }
}

extension ThemeManager {
    static var previewInstance: ThemeManager {
        let manager = ThemeManager()
        manager.appPrimary = .blue
        return manager
    }
}
