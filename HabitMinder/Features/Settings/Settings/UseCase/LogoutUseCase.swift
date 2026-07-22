//
//  LogoutUseCase.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import Foundation

@MainActor
protocol LogoutUseCasing {
    func logout()
}

@MainActor
final class LogoutUseCase: LogoutUseCasing {
    private let dataManager: DataManaging
    private let reminderScheduler: HabitReminderScheduling
    private let userDefaultsStorage: UserDefaultsStoring
    private let themeManager: ThemeManaging
    private let profileImageStorage: ProfileImageStoring

    init(
        dataManager: DataManaging,
        reminderScheduler: HabitReminderScheduling,
        userDefaultsStorage: UserDefaultsStoring,
        themeManager: ThemeManaging,
        profileImageStorage: ProfileImageStoring
    ) {
        self.dataManager = dataManager
        self.reminderScheduler = reminderScheduler
        self.userDefaultsStorage = userDefaultsStorage
        self.themeManager = themeManager
        self.profileImageStorage = profileImageStorage
    }

    func logout() {
        reminderScheduler.cancelAllNotifications()

        dataManager.deleteAll(HabitModel.self)
        dataManager.deleteAll(HabitHistoryModel.self)

        profileImageStorage.deleteAllProfileImages()
        userDefaultsStorage.removeAllAppValues()
        themeManager.resetToDefault()
    }
}
