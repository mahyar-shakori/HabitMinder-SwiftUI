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
    private let reminderScheduler: HabitReminderScheduling
    private let userDefaultsStorage: UserDefaultsStoring
    private let themeManager: ThemeManaging

    init(
        dataManager: DataManaging,
        reminderScheduler: HabitReminderScheduling,
        userDefaultsStorage: UserDefaultsStoring,
        themeManager: ThemeManaging,
        profileImageStorage: ProfileImageStoring
    ) {
        self.reminderScheduler = reminderScheduler
        self.userDefaultsStorage = userDefaultsStorage
        self.themeManager = themeManager
    }

    func logout() {
        reminderScheduler.cancelAllNotifications()
        userDefaultsStorage.save(value: false, for: UserDefaultKeys.isLogin)
        userDefaultsStorage.removeValue(for: UserDefaultKeys.currentAccountID)
        themeManager.loadStoredTheme()
    }
}
