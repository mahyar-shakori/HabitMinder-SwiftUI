//
//  AppDependencies.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation
import SwiftData

enum AppDependencies {
    static let themeManager: ThemeManager = DIContainer.shared.resolveOptional(fallback: ThemeManager())
    static let userDefaultsStoring: UserDefaultsStorage = DIContainer.shared.resolveOptional(fallback: UserDefaultsStorage())
//    static let fetchQuoteUseCase: FetchQuoteUseCase = DIContainer.shared.resolveOptional(
//        scope: .feature(.welcome),
//        fallback: FetchQuoteUseCase()
//    )
    static let introRouting: IntroRouting = DIContainer.shared.resolveOptional(fallback: IntroRouter())
    static let mainRouting: MainRouting = DIContainer.shared.resolveOptional(fallback: MainRouter())
    
    static let mainCoordinator: MainCoordinator = MainCoordinator(
        introRouting: introRouting,
        mainRouting: mainRouting,
        userDefaultsStorage: userDefaultsStoring
    )
}
