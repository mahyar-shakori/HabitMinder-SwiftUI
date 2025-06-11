//
//  HabitMinderAppTests.swift
//  HabitMinder SwiftUITests
//
//  Created by Mahyar on 11/06/2025.
//

import Testing
@testable import HabitMinder

@Suite
struct HabitMinderAppTests {
    
    @Test("RootView initializes with injected dependencies")
    func testRootViewInitialization() {
        // Arrange
        let introRouter = MockIntroRouter()
        let homeRouter = MockHomeRouter()
        let themeManager = MockThemeManager()

        let coordinator = MainCoordinator(
            introRouting: introRouter,
            homeRouting: homeRouter
        )

        // Act
        let rootView = RootView(coordinator: coordinator)
            .environmentObject(LanguageManager.shared)
            .environmentObject(themeManager)
        
        // Assert
        #expect(type(of: rootView) != Never.self)

    }
    
    @Test("ThemeManager injected into environment")
    func testThemeManagerInjection() {
        // Arrange
        let themeManager = MockThemeManager()
        _ = RootView(coordinator: MainCoordinator(
            introRouting: MockIntroRouter(),
            homeRouting: MockHomeRouter()
        )).environmentObject(themeManager)

        // Act & Assert
        #expect(themeManager.appPrimary == .red)
    }
    
    @Test("LanguageManager is shared and injected")
    func testLanguageManagerInjection() {
        // Arrange
        let shared = LanguageManager.shared
        _ = RootView(coordinator: MainCoordinator(
            introRouting: MockIntroRouter(),
            homeRouting: MockHomeRouter()
        )).environmentObject(shared)

        // Act & Assert
        #expect(shared.selectedLanguage == .en)
    }
}
