//
//  ScopesDependencies.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

struct AppDestinationDependencies {
    let intro: IntroDestinationDependencies
    let main: MainDestinationDependencies
}

struct MainDestinationDependencies {
    let habits: HabitDestinationDependencies
    let manageHabit: ManageHabitDestinationDependencies
    let settings: SettingsDestinationDependencies
}

struct IntroDestinationDependencies {
    let userDefaultsStorage: UserDefaultsStoring
    let quoteRepository: QuoteRepositoryProtocol
}

struct HabitDestinationDependencies {
    let userDefaultsStorage: UserDefaultsStoring
    let connectivityService: WatchConnectivityProviding
    let reminderScheduler: HabitReminderScheduling
}

struct ManageHabitDestinationDependencies {
    let reminderScheduler: HabitReminderScheduling
}

struct SettingsDestinationDependencies {
    let userDefaultsStorage: UserDefaultsStoring
    let reminderScheduler: HabitReminderScheduling
    let themeManager: ThemeManaging
    let profileImageStorage: ProfileImageStoring
    let profileImageUseCase: ProfileImageUseCasing
}
