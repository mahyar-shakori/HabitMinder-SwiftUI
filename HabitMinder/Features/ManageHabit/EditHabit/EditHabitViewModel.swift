//
//  EditHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

@MainActor
final class EditHabitViewModel: ObservableObject {
    @Published private(set) var uiState = EditHabitUIState()

    private let habitID: UUID
    private let dataManager: DataManaging
    private let coordinator: EditHabitCoordinating
    private let reminderScheduler: HabitReminderScheduling

    private var trimmedHabitTitle: String {
        uiState.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
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

           uiState.habitTitle = habit.title
           uiState.selectedIconName = habit.iconName
           uiState.selectedFrequency =
               HabitFrequency(rawValue: habit.frequency) ?? .daily

           uiState.selectedCustomWeekdays = habit.customWeekdays.isEmpty
               ? [Calendar.current.component(.weekday, from: Date())]
               : habit.customWeekdays

           uiState.commitmentDays = habit.commitmentDays
           uiState.reminderTimes = habit.reminderTimes.sorted()

           updateValidationState()
       }
    
    func setHabitTitle(_ newValue: String) {
        uiState.habitTitle = newValue
        updateValidationState()
    }

    func setSelectedIconName(_ iconName: String) {
        uiState.selectedIconName = iconName
    }

    func setSelectedFrequency(_ frequency: HabitFrequency) {
        uiState.selectedFrequency = frequency
    }

    func toggleCustomWeekday(_ weekday: Int) {
        if uiState.selectedCustomWeekdays.contains(weekday) {
            guard uiState.selectedCustomWeekdays.count > 1 else {
                return
            }
            uiState.selectedCustomWeekdays.removeAll { $0 == weekday }
        } else {
            uiState.selectedCustomWeekdays.append(weekday)
        }

        uiState.selectedCustomWeekdays.sort()
    }

    func incrementCommitmentDays() {
        uiState.commitmentDays += 1
    }

    func decrementCommitmentDays() {
        uiState.commitmentDays = max(1, uiState.commitmentDays - 1)
    }

    func addReminderTime(_ time: String) {
        reminderScheduler.getAuthorizationStatus { [weak self] status in
            guard let self else {
                return
            }

            switch status {
            case .allowed:
                DispatchQueue.main.async {
                    self.insertReminderTime(time)
                }
            case .notDetermined:
                Task { @MainActor in
                    self.requestNotificationAuthorization(for: time)
                }
            case .denied:
                DispatchQueue.main.async {
                    self.uiState.isNotificationSettingsAlertPresented = true
                }
            }
        }
    }

    func dismissNotificationSettingsAlert() {
        uiState.isNotificationSettingsAlertPresented = false
    }

    func removeReminderTime(at offsets: IndexSet) {
        uiState.reminderTimes.remove(atOffsets: offsets)
    }
    
    private func updateValidationState() {
        let isValid = trimmedHabitTitle.count > 0
        uiState.isSaveButtonEnabled = isValid
    }

    private func requestNotificationAuthorization(for time: String) {
        reminderScheduler.requestAuthorization { [weak self] isAllowed in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }

                if isAllowed {
                    self.insertReminderTime(time)
                } else {
                    self.uiState.isNotificationSettingsAlertPresented = true
                }
            }
        }
    }

    private func insertReminderTime(_ time: String) {
        guard uiState.reminderTimes.count < 10,
              uiState.reminderTimes.contains(time).not else {
            return
        }

        uiState.reminderTimes.append(time)
        uiState.reminderTimes.sort()
    }

    
    func saveAndDismiss() {
        dataManager.update({ habit in
            habit.title = trimmedHabitTitle
            habit.iconName = uiState.selectedIconName
            habit.frequency = uiState.selectedFrequency.rawValue
            habit.commitmentDays = uiState.commitmentDays
            habit.reminderTimes = uiState.reminderTimes
            habit.customWeekdays = uiState.selectedCustomWeekdays
        }, forID: habitID, HabitModel.self)

        reminderScheduler.scheduleReminders(
            for: habitID,
            title: trimmedHabitTitle,
            times: uiState.reminderTimes,
            frequency: uiState.selectedFrequency,
            customWeekdays: uiState.selectedCustomWeekdays
        )
        NotificationCenter.default.post(name: AppNotification.Habit.edited, object: nil)
        coordinator.goBack()
    }
    
    func missHabit() {
        dataManager.update({ $0.createdAt = Date() }, forID: habitID, HabitModel.self)
    }
    
    func missHabitAndShowToast() {
        missHabit()
        uiState.showToast = true
        
        Task {
            await Task.delay()
            await MainActor.run {
                uiState.showToast = false
            }
        }
    }
}
