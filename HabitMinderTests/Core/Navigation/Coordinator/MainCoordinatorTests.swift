//
//  MainCoordinatorTests.swift
//  HabitMinder
//
//  Created by Mahyar on 17/06/2025.
//

import Testing
@testable import HabitMinder
import Foundation

@Suite
struct MainCoordinatorTests {
    
    @Test("pop() should remove the last item from the path if not empty")
    func testPopRemovesLastItemWhenPathIsNotEmpty() {
        // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        coordinator.path = [
            NavigationItem(route: .intro(.intro)),
            NavigationItem(route: .intro(.setName))
        ]
        
        // Act
        coordinator.pop()
        
        // Assert
        #expect(coordinator.path.count == 1)
    }
    
    @Test("pop() should do nothing when the path is already empty")
    func testPopDoesNothingWhenPathIsEmpty() {
    // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        coordinator.path = []
        
        // Act
        coordinator.pop()
        
        // Assert
        #expect(coordinator.path.isEmpty)
    }
    
    @Test("popToRoot() keeps only the first item when path has multiple elements")
    func testPopToRootKeepsOnlyFirstItemWhenPathHasMultipleItems() {
        // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        let firstItem = NavigationItem(route: .intro(.intro))
        coordinator.path = [
            firstItem,
            NavigationItem(route: .intro(.welcome)),
            NavigationItem(route: .home(.home(quote: "test")))
        ]
        
        // Act
        coordinator.popToRoot()
        
        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first == firstItem)
    }
    
    @Test("popToRoot() does nothing when path is empty")
    func testPopToRootDoesNothingWhenPathIsEmpty() {
        // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        coordinator.path = []
        
        // Act
        coordinator.popToRoot()
        
        // Assert
        #expect(coordinator.path.isEmpty)
    }
    
    @Test("start() navigates to .intro(.intro) if user is not logged in")
    func testStartNavigatesToIntroPageWhenUserIsNotLoggedIn() {
        // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults(initialLoginValue: false)
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        
        // Act
        coordinator.start()
        
        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first?.route == .intro(.intro))
    }
    
    @Test("start() navigates to .intro(.welcome) if user is logged in")
    func testStartNavigatesToWelcomePageWhenUserIsLoggedIn() {
        // Arrange
        let userDefaultsContainer = DIContainer.UserDefaults(initialLoginValue: true)
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        
        // Act
        coordinator.start()
        
        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first?.route == .intro(.welcome))
    }
    
    @Test("navigate(to:) appends route to path")
    func testNavigateAppendsRouteToPath() {
        // Arrange
        let route: AppRoute = .intro(.welcome)
        let userDefaultsContainer = DIContainer.UserDefaults()
        
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            loginStorage: userDefaultsContainer.loginStorage
        )
        
        // Act
        coordinator.navigate(to: route)
        
        // Assert
        #expect(coordinator.path.last?.route == route)
    }
}
