//
//  AppDependencies.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

struct AppDependencies {
    private let container: DIContainer

    init(container: DIContainer = DISetup.makeContainer()) {
        self.container = container
    }

    var themeManager: ThemeManager {
        container.resolve(ThemeManager.self)
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
        SettingsDestinationDependencies(
            userDefaultsStorage: container.resolve(UserDefaultsStoring.self)
        )
    }
}
