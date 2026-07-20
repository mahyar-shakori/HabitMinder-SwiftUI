//
//  AddHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation

@MainActor
final class AddHabitViewModel: ObservableObject {
    @Published private(set) var uiState = AddHabitUIState()
    
    private let dataManager: DataManaging
    private let coordinator: AddHabitCoordinating
    private let reminderScheduler: HabitReminderScheduling
    
    private var trimmedHabitTitle: String {
        uiState.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var selectedIconName: String {
        uiState.selectedIconName.isEmpty ? SystemIconName.checkmark : uiState.selectedIconName
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

    func setIsFutureHabit(_ isFutureHabit: Bool) {
        uiState.isFutureHabit = isFutureHabit
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
        if uiState.isFutureHabit {
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
            frequency: uiState.selectedFrequency.rawValue,
            commitmentDays: uiState.commitmentDays,
            reminderTimes: uiState.reminderTimes,
            customWeekdays: uiState.selectedCustomWeekdays
        )

        dataManager.save(newHabit)
        reminderScheduler.scheduleReminders(
            for: newHabit.id,
            title: newHabit.title,
            times: newHabit.reminderTimes,
            frequency: uiState.selectedFrequency,
            customWeekdays: uiState.selectedCustomWeekdays
        )
        NotificationCenter.default.post(name: AppNotification.Habit.added, object: nil)
    }

    private func saveFutureHabit() {
        let newHabit = FutureHabitModel(
            title: trimmedHabitTitle,
            iconName: selectedIconName,
            frequency: uiState.selectedFrequency.rawValue,
            commitmentDays: uiState.commitmentDays,
            reminderTimes: uiState.reminderTimes,
            customWeekdays: uiState.selectedCustomWeekdays
        )
        dataManager.save(newHabit)
        NotificationCenter.default.post(name: AppNotification.Habit.futureAdded, object: nil)
    }
}
