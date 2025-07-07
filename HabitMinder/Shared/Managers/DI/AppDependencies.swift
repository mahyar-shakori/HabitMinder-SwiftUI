//
//  AppDependencies.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

enum AppDependencies {
    static let themeManager: ThemeManager = DIContainer.shared.resolveOptional(fallback: ThemeManager())
    static let userDefaultsStorage: UserDefaultsStoring = DIContainer.shared.resolveOptional(fallback: UserDefaultsStorage())
    static let introRouting: IntroRouting = DIContainer.shared.resolveOptional(fallback: IntroRouter())
    static let mainRouting: MainRouting = DIContainer.shared.resolveOptional(fallback: MainRouter())

    static let mainCoordinator: MainCoordinator = MainCoordinator(
        introRouting: introRouting,
        mainRouting: mainRouting,
        userDefaultsStorage: userDefaultsStorage
    )
}
