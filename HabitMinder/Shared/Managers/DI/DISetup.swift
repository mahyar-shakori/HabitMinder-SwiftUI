//
//  DISetup.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

@MainActor
struct DISetup {
    static func makeContainer() -> DIContainer {
        let container = DIContainer()

        registerUserDefaults(in: container)
        registerProfileImageStorage(in: container)
        registerAPIService(in: container)
        registerQuoteRepository(in: container)
        registerWatchConnectivity(in: container)
        registerHabitReminderScheduler(in: container)
        registerThemeManager(in: container)
        registerMainCoordinator(in: container)

        return container
    }
}

private extension DISetup {
    static func registerUserDefaults(in container: DIContainer) {
        container.register(UserDefaultsStoring.self) { _ in
            UserDefaultsStorage()
        }
    }

    static func registerProfileImageStorage(in container: DIContainer) {
        container.register(ProfileImageStoring.self) { _ in
            ProfileImageStorage()
        }
    }

    static func registerAPIService(in container: DIContainer) {
        container.register(APIFetching.self) { _ in
            APIService()
        }
    }

    static func registerQuoteRepository(in container: DIContainer) {
        container.register(QuoteRepositoryProtocol.self) { container in
            QuoteRepository(
                apiService: container.resolve(APIFetching.self)
            )
        }
    }

    static func registerWatchConnectivity(in container: DIContainer) {
        container.register(WatchConnectivityProviding.self) { _ in
            WatchConnectivityService()
        }
    }

    static func registerHabitReminderScheduler(in container: DIContainer) {
        container.register(HabitReminderScheduling.self) { container in
            let scheduler = HabitReminderScheduler(
                userDefaultsStorage: container.resolve(UserDefaultsStoring.self)
            )
            scheduler.configureForegroundPresentation()
            return scheduler
        }
    }

    static func registerThemeManager(in container: DIContainer) {
        container.register(ThemeManager.self) { container in
            ThemeManager(
                userDefaultsStorage: container.resolve(UserDefaultsStoring.self)
            )
        }
    }

    static func registerMainCoordinator(in container: DIContainer) {
        container.register(MainCoordinator.self) { container in
            MainCoordinator(
                userDefaultsStorage: container.resolve(UserDefaultsStoring.self)
            )
        }
    }
}
