//
//  MainCoordinator.swift.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation
import Observation

@Observable
final class MainCoordinator {
    var path: [NavigationItem] = []
    private let userDefaultsStorage: UserDefaultsStoring
    
    init(userDefaultsStorage: UserDefaultsStoring) {
        self.userDefaultsStorage = userDefaultsStorage
    }
}

extension MainCoordinator: MainCoordinating {
    func navigate(to route: AppRoute) {
        guard canNavigate(to: route) else {
            return
        }

        let item = NavigationItem(route: route)
        path.append(item)
    }
    
    func pop() {
        guard path.isNotEmpty else {
            return
        }
        path.removeLast()
    }
    
    func popToRoot() {
        guard let root = path.first else {
            return
        }
        path = [root]
    }

    func reset(to route: AppRoute) {
        path = [NavigationItem(route: route)]
    }
    
    func start() {
        guard path.isEmpty else {
            return
        }
        let initialRoute: AppRoute = hasValidSession ? .intro(.welcome) : .intro(.onboarding)
        path = [NavigationItem(route: initialRoute)]
    }

    private var hasValidSession: Bool {
        let isLoggedIn = userDefaultsStorage.fetch(for: UserDefaultKeys.isLogin) ?? false
        let currentAccountID: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.currentAccountID)
        let hasAccountID = currentAccountID?.isEmpty == false

        return isLoggedIn && hasAccountID
    }

    private func canNavigate(to route: AppRoute) -> Bool {
        switch route {
        case .intro:
            return true
        case .main:
            return hasValidSession
        }
    }
}
