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
        let userDefaultsStorage = UserDefaultsStorage()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        coordinator.path = [
            NavigationItem(route: .intro(.onboarding)),
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
        let userDefaultsStorage = UserDefaultsStorage()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
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
        let userDefaultsStorage = UserDefaultsStorage()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        let firstItem = NavigationItem(route: .intro(.onboarding))
        coordinator.path = [
            firstItem,
            NavigationItem(route: .intro(.welcome)),
            NavigationItem(route: .main(.home(quote: "test")))
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
        let userDefaultsStorage = UserDefaultsStorage()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
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
        let userDefaultsStorage = UserDefaultsStorage()
        userDefaultsStorage.save(value: false, for: UserDefaultKeys.isLogin)
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        
        // Act
        coordinator.start()
        
        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first?.route == .intro(.onboarding))
    }
    
    @Test("start() navigates to .intro(.welcome) if user is logged in")
    func testStartNavigatesToWelcomePageWhenUserIsLoggedIn() {
        // Arrange
        let userDefaultsStorage = UserDefaultsStorage()
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        
        // Act
        coordinator.start()
        
        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first?.route == .intro(.onboarding))
    }
    
    @Test("navigate(to:) appends route to path")
    func testNavigateAppendsRouteToPath() {
        // Arrange
        let route: AppRoute = .intro(.welcome)
        let userDefaultsStorage = UserDefaultsStorage()
        
        let coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            mainRouting: MainRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        
        // Act
        coordinator.navigate(to: route)
        
        // Assert
        #expect(coordinator.path.last?.route == route)
    }
}
