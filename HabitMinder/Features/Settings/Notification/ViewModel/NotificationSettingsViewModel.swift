//
//  NotificationSettingsViewModel.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class NotificationSettingsViewModel {
    private(set) var allowNotifications: Bool
    private(set) var dailyReminders: Bool
    private(set) var journeyCompletionNotifications: Bool
    private(set) var dailyQuotes: Bool

    private let dataManager: DataManaging
    private let reminderScheduler: HabitReminderScheduling
    private let userDefaultsStorage: UserDefaultsStoring

    var dailyRemindersToggleValue: Bool {
        allowNotifications && dailyReminders
    }

    var journeyCompletionToggleValue: Bool {
        allowNotifications && journeyCompletionNotifications
    }

    init(
        dataManager: DataManaging,
        reminderScheduler: HabitReminderScheduling,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.dataManager = dataManager
        self.reminderScheduler = reminderScheduler
        self.userDefaultsStorage = userDefaultsStorage
        self.allowNotifications = userDefaultsStorage.fetch(for: UserDefaultKeys.allowNotifications) ?? true
        self.dailyReminders = userDefaultsStorage.fetch(for: UserDefaultKeys.dailyReminders) ?? true
        self.journeyCompletionNotifications = userDefaultsStorage.fetch(for: UserDefaultKeys.journeyCompletionNotifications) ?? true
        self.dailyQuotes = userDefaultsStorage.fetch(for: UserDefaultKeys.dailyQuotes) ?? true
    }

    func setAllowNotifications(_ isAllowed: Bool) {
        allowNotifications = isAllowed
        userDefaultsStorage.save(value: isAllowed, for: UserDefaultKeys.allowNotifications)

        if isAllowed {
            if dailyReminders {
                scheduleStoredDailyReminders()
            }
        } else {
            setDailyRemindersValue(false)
            setJourneyCompletionNotificationsValue(false)
            reminderScheduler.cancelAllNotifications()
        }
    }

    func setDailyReminders(_ isEnabled: Bool) {
        let newValue = allowNotifications && isEnabled
        setDailyRemindersValue(newValue)

        if newValue {
            scheduleStoredDailyReminders()
        } else {
            reminderScheduler.cancelDailyReminders()
        }
    }

    func setJourneyCompletionNotifications(_ isEnabled: Bool) {
        setJourneyCompletionNotificationsValue(allowNotifications && isEnabled)
    }

    func setDailyQuotes(_ isEnabled: Bool) {
        dailyQuotes = isEnabled
        userDefaultsStorage.save(value: isEnabled, for: UserDefaultKeys.dailyQuotes)
        NotificationCenter.default.post(name: AppNotification.Settings.updated, object: nil)
    }

    private func setDailyRemindersValue(_ isEnabled: Bool) {
        dailyReminders = isEnabled
        userDefaultsStorage.save(value: isEnabled, for: UserDefaultKeys.dailyReminders)
    }

    private func setJourneyCompletionNotificationsValue(_ isEnabled: Bool) {
        journeyCompletionNotifications = isEnabled
        userDefaultsStorage.save(value: isEnabled, for: UserDefaultKeys.journeyCompletionNotifications)
    }

    private func scheduleStoredDailyReminders() {
        let habits = dataManager.fetchAll(HabitModel.self)
        habits
            .filter { $0.reminderTimes.isNotEmpty }
            .forEach { habit in
                reminderScheduler.scheduleReminders(
                    for: habit.id,
                    title: habit.title,
                    times: habit.reminderTimes,
                    frequency: HabitFrequency(rawValue: habit.frequency) ?? .daily,
                    customWeekdays: habit.customWeekdays
                )
            }
    }
}
