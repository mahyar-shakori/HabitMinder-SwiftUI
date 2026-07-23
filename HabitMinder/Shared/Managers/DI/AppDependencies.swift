//
//  AppDependencies.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

@MainActor
struct AppDependencies {
    private let container: DIContainer

    init(container: DIContainer = DISetup.makeContainer()) {
        self.container = container
    }

    var themeManager: ThemeManager {
        container.resolve(ThemeManager.self)
    }

    var reminderScheduler: HabitReminderScheduling {
        container.resolve(HabitReminderScheduling.self)
    }

    var mainCoordinator: MainCoordinator {
        container.resolve(MainCoordinator.self)
    }

    var destinationDependencies: AppDestinationDependencies {
        AppDestinationDependencies(
            intro: introDependencies,
            main: mainDependencies
        )
    }

    private var introDependencies: IntroDestinationDependencies {
        IntroDestinationDependencies(
            userDefaultsStorage: container.resolve(UserDefaultsStoring.self),
            quoteRepository: container.resolve(QuoteRepositoryProtocol.self)
        )
    }

    private var mainDependencies: MainDestinationDependencies {
        MainDestinationDependencies(
            habits: habitDependencies,
            manageHabit: manageHabitDependencies,
            settings: settingsDependencies
        )
    }

    private var habitDependencies: HabitDestinationDependencies {
        HabitDestinationDependencies(
            userDefaultsStorage: container.resolve(UserDefaultsStoring.self),
            connectivityService: container.resolve(WatchConnectivityProviding.self),
            reminderScheduler: container.resolve(HabitReminderScheduling.self)
        )
    }

    private var manageHabitDependencies: ManageHabitDestinationDependencies {
        ManageHabitDestinationDependencies(
            reminderScheduler: container.resolve(HabitReminderScheduling.self)
        )
    }

    private var settingsDependencies: SettingsDestinationDependencies {
        let userDefaultsStorage = container.resolve(UserDefaultsStoring.self)
        let profileImageStorage = container.resolve(ProfileImageStoring.self)

        return SettingsDestinationDependencies(
            userDefaultsStorage: userDefaultsStorage,
            reminderScheduler: container.resolve(HabitReminderScheduling.self),
            themeManager: container.resolve(ThemeManager.self),
            profileImageStorage: profileImageStorage,
            profileImageUseCase: ProfileImageUseCase(
                userDefaultsStorage: userDefaultsStorage,
                profileImageStorage: profileImageStorage
            )
        )
    }
}
