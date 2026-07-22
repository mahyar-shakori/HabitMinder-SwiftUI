//
//  EditHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class EditHabitViewModel {
    private(set) var habitTitle = ""
    private(set) var selectedIconName = ""
    private(set) var selectedFrequency = HabitFrequency.daily
    private(set) var selectedCustomWeekdays = [Calendar.current.component(.weekday, from: Date())]
    private(set) var commitmentDays = 21
    private(set) var reminderTimes: [String] = []
    private(set) var isFutureHabit = false
    private(set) var isSaveButtonEnabled = false
    private(set) var isNotificationSettingsAlertPresented = false
    private(set) var notificationAlertOpensAppSettings = false
    private(set) var showToast = false
    private let habitID: UUID
    private let dataManager: DataManaging
    private let coordinator: EditHabitCoordinating
    private let reminderScheduler: HabitReminderScheduling

    private var trimmedHabitTitle: String {
        habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var selectedIconNames: String {
        selectedIconName.isEmpty ? SystemIconName.checkmark : selectedIconName
    }
    
    init(
        dataManager: DataManaging,
        coordinator: EditHabitCoordinating,
        habitID: UUID,
        reminderScheduler: HabitReminderScheduling
    ) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.habitID = habitID
        self.reminderScheduler = reminderScheduler

        loadHabit()
    }
    
    private func loadHabit() {
        guard let habit = dataManager.fetch(byID: habitID, HabitModel.self) else {
            return
        }

        habitTitle = habit.title
        selectedIconName = habit.iconName.isEmpty ? SystemIconName.checkmark : habit.iconName
        selectedFrequency = HabitFrequency(rawValue: habit.frequency) ?? .daily

        selectedCustomWeekdays = habit.customWeekdays.isEmpty
            ? [Calendar.current.component(.weekday, from: Date())]
            : habit.customWeekdays

        commitmentDays = habit.commitmentDays
        reminderTimes = habit.reminderTimes.sorted()

        updateValidationState()
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
        guard reminderScheduler.areDailyRemindersEnabled else {
            showNotificationAlert(opensAppSettings: false)
            return
        }

        reminderScheduler.getAuthorizationStatus { [weak self] status in
            guard let self else {
                return
            }

            switch status {
            case .allowed:
                self.insertReminderTime(time)
            case .notDetermined:
                self.showNotificationAlert(opensAppSettings: false)
            case .denied:
                self.showNotificationAlert(opensAppSettings: true)
            }
        }
    }

    func dismissNotificationSettingsAlert() {
        isNotificationSettingsAlertPresented = false
        notificationAlertOpensAppSettings = false
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

    private func showNotificationAlert(opensAppSettings: Bool) {
        notificationAlertOpensAppSettings = opensAppSettings
        isNotificationSettingsAlertPresented = true
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
            moveHabitToFuture()
        } else {
            updateCurrentHabit()
        }
        coordinator.goBack()
    }

    private func updateCurrentHabit() {
        dataManager.update({ habit in
            habit.title = trimmedHabitTitle
            habit.iconName = selectedIconNames
            habit.frequency = selectedFrequency.rawValue
            habit.commitmentDays = commitmentDays
            habit.reminderTimes = reminderTimes
            habit.customWeekdays = selectedCustomWeekdays
        }, forID: habitID, HabitModel.self)

        reminderScheduler.scheduleReminders(
            for: habitID,
            title: trimmedHabitTitle,
            times: reminderTimes,
            frequency: selectedFrequency,
            customWeekdays: selectedCustomWeekdays
        )
        NotificationCenter.default.post(name: AppNotification.Habit.edited, object: nil)
    }

    private func moveHabitToFuture() {
        let futureHabit = HabitHistoryModel(
            title: trimmedHabitTitle,
            iconName: selectedIconNames,
            frequency: selectedFrequency.rawValue,
            commitmentDays: commitmentDays,
            reminderTimes: reminderTimes,
            customWeekdays: selectedCustomWeekdays
        )

        dataManager.save(futureHabit)
        dataManager.delete(byID: habitID, HabitModel.self)
        reminderScheduler.cancelReminders(for: habitID)
        NotificationCenter.default.post(name: AppNotification.Habit.futureAdded, object: nil)
    }
    
    func missHabit() {
        dataManager.update({ $0.createdAt = Date() }, forID: habitID, HabitModel.self)
    }
    
    func missHabitAndShowToast() {
        missHabit()
        showToast = true
        
        Task {
            await Task.delay()
            showToast = false
        }
    }
}
