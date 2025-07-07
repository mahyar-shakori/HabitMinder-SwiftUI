//
//  DISetup.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

struct DISetup {
    static func registerAllDependencies() {
        registerGlobalDependencies()
        registerScopedDependencies()
    }

    private static func registerGlobalDependencies() {
        DIContainer.shared.register {
            IntroRouter() as IntroRouting
        }

        DIContainer.shared.register {
            MainRouter() as MainRouting
        }
        
        DIContainer.shared.register {
            UserDefaultsStorage() as UserDefaultsStoring
        }
        
        DIContainer.shared.register {
            UserDefaultsStorage() as UserDefaultsStoring
        }
        
        DIContainer.shared.register {
            ThemeManager() as ThemeManaging
        }
    }

    private static func registerScopedDependencies() {
        DIContainer.shared.register(scope: .feature(.welcome)) {
            APIService(configuration: .init(timeoutInterval: 3)) as APIFetching
        }
    }
}
