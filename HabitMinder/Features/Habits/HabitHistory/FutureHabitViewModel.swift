//
//  FutureHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class FutureHabitViewModel: ObservableObject {
    @Published private(set) var uiState = FutureHabitUIState()
    
    private let dataManager: DataManaging
    private let coordinator: HabitHistoryCoordinating
    private let reminderScheduler: HabitReminderScheduling
    private var habitTitle = ""
    
    private var trimmedHabitTitle: String {
        habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var deleteConfirmationMessage: String {
        guard let itemToDelete = uiState.itemToDelete,
              let title = uiState.listItems.first(where: { $0.id == itemToDelete })?.title else {
            return LocalizedStrings.Alert.Habit.deleteMessage
        }

        return "Are you sure you want to delete \"\(title)\"?"
    }
    
    init(
        dataManager: DataManaging,
        coordinator: HabitHistoryCoordinating,
        reminderScheduler: HabitReminderScheduling
    ) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.reminderScheduler = reminderScheduler
        fetchHabits()
    }
    
    func setHabitTitle(_ newValue: String) {
        habitTitle = newValue
        updateValidationState()
    }
   
    func fetchHabits() {
        let futureHabitModels: [FutureHabitModel] = dataManager.fetchAll(FutureHabitModel.self)
        let completedHabitModels: [HabitModel] = dataManager.fetchAll(HabitModel.self)
            .filter { $0.createdAt.habitDaysCountSinceCreation(for: $0.id, totalDays: $0.commitmentDays) == 0 }
            .sorted { $0.createdAt > $1.createdAt }

        completedHabitModels.forEach {
            reminderScheduler.cancelReminders(for: $0.id)
        }

        uiState.listItems = futureHabitModels.map {
            FutureHabitItem(
                id: $0.id,
                title: $0.title,
                dateCreate: $0.createdAt,
                iconName: $0.iconName,
                commitmentDays: $0.commitmentDays
            )
        }
        uiState.completedItems = completedHabitModels.map {
            CompletedHabitItem(
                id: $0.id,
                title: $0.title,
                completedAt: completedDate(for: $0),
                iconName: $0.iconName,
                commitmentDays: $0.commitmentDays
            )
        }
    }
    
    private func updateValidationState() {
        let isValid = trimmedHabitTitle.count > 0
        uiState.isSaveButtonEnabled = isValid
    }
 
    func save() {
            let newHabit = FutureHabitModel(title: habitTitle)
            dataManager.save(newHabit)
            habitTitle = ""
            fetchHabits()
        }
    
    func startHabit(id: UUID) {
        guard let futureHabit = dataManager.fetch(byID: id, FutureHabitModel.self) else {
            return
        }

        let maxSortOrder = dataManager
            .fetchAll(HabitModel.self)
            .map(\.sortOrder)
            .max() ?? -1
        let habit = HabitModel(
            title: futureHabit.title,
            sortOrder: maxSortOrder + 1,
            iconName: futureHabit.iconName,
            frequency: futureHabit.frequency,
            commitmentDays: futureHabit.commitmentDays,
            reminderTimes: futureHabit.reminderTimes,
            customWeekdays: futureHabit.customWeekdays
        )

        dataManager.save(habit)
        dataManager.delete(byID: id, FutureHabitModel.self)
        reminderScheduler.scheduleReminders(
            for: habit.id,
            title: habit.title,
            times: habit.reminderTimes,
            frequency: HabitFrequency(rawValue: habit.frequency) ?? .daily,
            customWeekdays: habit.customWeekdays
        )
        fetchHabits()
        NotificationCenter.default.post(name: AppNotification.Habit.futureStarted, object: nil)
    }

    func confirmDelete(id: UUID) {
        uiState.itemToDelete = id
    }
    
    func performDelete() {
        guard let id = uiState.itemToDelete else {
            return
        }
        reminderScheduler.cancelReminders(for: id)
        dataManager.delete(byID: id, FutureHabitModel.self)
        uiState.listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        uiState.itemToDelete = nil
    }

    private func completedDate(for habit: HabitModel) -> Date {
        Calendar.current.date(byAdding: .day, value: habit.commitmentDays, to: habit.createdAt) ?? habit.createdAt
    }
    
    func dismiss() {
        coordinator.goBack()
    }
}
