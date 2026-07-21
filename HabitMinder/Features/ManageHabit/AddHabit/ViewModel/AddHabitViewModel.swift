//
//  AddHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class AddHabitViewModel {
    private var habitTitle = ""
    private(set) var selectedIconName = ""
    private(set) var selectedFrequency = HabitFrequency.daily
    private(set) var selectedCustomWeekdays = [Calendar.current.component(.weekday, from: Date())]
    private(set) var commitmentDays = 21
    private(set) var reminderTimes: [String] = []
    private(set) var isFutureHabit = false
    private(set) var isSaveButtonEnabled = false
    private(set) var isNotificationSettingsAlertPresented = false
    private let dataManager: DataManaging
    private let coordinator: AddHabitCoordinating
    private let reminderScheduler: HabitReminderScheduling
    
    private var trimmedHabitTitle: String {
        habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var selectedIconNames: String {
        selectedIconName.isEmpty ? SystemIconName.checkmark : selectedIconName
    }
    
    init(
        dataManager: DataManaging,
        coordinator: AddHabitCoordinating,
        reminderScheduler: HabitReminderScheduling
    ) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.reminderScheduler = reminderScheduler
    }
    
    func setHabitTitle(_ newValue: String) {
        habitTitle = newValue
        updateValidationState()
    }

    func setSelectedIconName(_ iconName: String) {
        selectedIconName = iconName
    }

    func setSelectedFrequency(_ frequency: HabitFrequency) {
        selectedFrequency = frequency
    }

    func toggleCustomWeekday(_ weekday: Int) {
        if selectedCustomWeekdays.contains(weekday) {
            guard selectedCustomWeekdays.count > 1 else {
                return
            }
            selectedCustomWeekdays.removeAll { $0 == weekday }
        } else {
            selectedCustomWeekdays.append(weekday)
        }

        selectedCustomWeekdays.sort()
    }

    func incrementCommitmentDays() {
        commitmentDays += 1
    }

    func decrementCommitmentDays() {
        commitmentDays = max(1, commitmentDays - 1)
    }

    func addReminderTime(_ time: String) {
        reminderScheduler.getAuthorizationStatus { [weak self] status in
            guard let self else {
                return
            }

            switch status {
            case .allowed:
                self.insertReminderTime(time)
            case .notDetermined:
                self.requestNotificationAuthorization(for: time)
            case .denied:
                self.isNotificationSettingsAlertPresented = true
            }
        }
    }

    func dismissNotificationSettingsAlert() {
        isNotificationSettingsAlertPresented = false
    }

    func removeReminderTime(at offsets: IndexSet) {
        reminderTimes.remove(atOffsets: offsets)
    }

    func setIsFutureHabit(_ isFutureHabit: Bool) {
        self.isFutureHabit = isFutureHabit
    }
    
    private func updateValidationState() {
        let isValid = trimmedHabitTitle.count > 0
        isSaveButtonEnabled = isValid
    }

    private func requestNotificationAuthorization(for time: String) {
        reminderScheduler.requestAuthorization { [weak self] isAllowed in
            guard let self else {
                return
            }

            if isAllowed {
                self.insertReminderTime(time)
            } else {
                self.isNotificationSettingsAlertPresented = true
            }
        }
    }

    private func insertReminderTime(_ time: String) {
        guard reminderTimes.count < 10,
              reminderTimes.contains(time).not else {
            return
        }

        reminderTimes.append(time)
        reminderTimes.sort()
    }
    
    func saveAndDismiss() {
        if isFutureHabit {
            saveFutureHabit()
        } else {
            saveCurrentHabit()
        }

        coordinator.goBack()
    }

    private func saveCurrentHabit() {
        let maxSortOrder = dataManager
            .fetchAll(HabitModel.self)
            .map(\.sortOrder)
            .max() ?? -1

        let newHabit = HabitModel(
            title: trimmedHabitTitle,
            sortOrder: maxSortOrder + 1,
            iconName: selectedIconName,
            frequency: selectedFrequency.rawValue,
            commitmentDays: commitmentDays,
            reminderTimes: reminderTimes,
            customWeekdays: selectedCustomWeekdays
        )

        dataManager.save(newHabit)
        reminderScheduler.scheduleReminders(
            for: newHabit.id,
            title: newHabit.title,
            times: newHabit.reminderTimes,
            frequency: selectedFrequency,
            customWeekdays: selectedCustomWeekdays
        )
        NotificationCenter.default.post(name: AppNotification.Habit.added, object: nil)
    }

    private func saveFutureHabit() {
        let newHabit = HabitHistoryModel(
            title: trimmedHabitTitle,
            iconName: selectedIconName,
            frequency: selectedFrequency.rawValue,
            commitmentDays: commitmentDays,
            reminderTimes: reminderTimes,
            customWeekdays: selectedCustomWeekdays
        )
        dataManager.save(newHabit)
        NotificationCenter.default.post(name: AppNotification.Habit.futureAdded, object: nil)
    }
}
