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
        guard path.isNotEmpty else { return }
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
        let isLoggedIn = userDefaultsStorage.fetch(for: UserDefaultKeys.isLogin) ?? false
        let initialRoute: AppRoute = isLoggedIn ? .intro(.welcome) : .intro(.onboarding)
        path = [NavigationItem(route: initialRoute)]
    }

    private func canNavigate(to route: AppRoute) -> Bool {
        switch route {
        case .intro:
            return true
        case .main:
            let isLoggedIn = userDefaultsStorage.fetch(for: UserDefaultKeys.isLogin) ?? false
            return isLoggedIn
        }
    }
}
