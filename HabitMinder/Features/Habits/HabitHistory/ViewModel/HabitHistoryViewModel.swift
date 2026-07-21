//
//  HabitHistoryViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation
import Observation

@Observable
final class HabitHistoryViewModel {
    private var isSaveButtonEnabled = false
    private(set) var listItems: [FutureHabitItem] = []
    private(set) var completedItems: [CompletedHabitItem] = []
    private(set) var itemToDelete: UUID?
    private let dataManager: DataManaging
    private let coordinator: HabitHistoryCoordinating
    private let reminderScheduler: HabitReminderScheduling
    private var habitTitle = ""
    
    private var trimmedHabitTitle: String {
        habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var deleteConfirmationMessage: String {
        guard let itemToDelete = itemToDelete,
              let title = listItems.first(where: { $0.id == itemToDelete })?.title else {
            return L10n.Alert.Habit.deleteMessage
        }

        return L10n.Alert.Habit.deleteMessage(title: title)
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
        let habitHistoryModels: [HabitHistoryModel] = dataManager.fetchAll(HabitHistoryModel.self)
        let completedHabitModels: [HabitModel] = dataManager.fetchAll(HabitModel.self)
            .filter { $0.createdAt.habitDaysCountSinceCreation(for: $0.id, totalDays: $0.commitmentDays) == 0 }
            .sorted { $0.createdAt > $1.createdAt }

        completedHabitModels.forEach {
            reminderScheduler.cancelReminders(for: $0.id)
        }

        listItems = habitHistoryModels.map {
            FutureHabitItem(
                id: $0.id,
                title: $0.title,
                dateCreate: $0.createdAt,
                iconName: $0.iconName,
                commitmentDays: $0.commitmentDays
            )
        }
        completedItems = completedHabitModels.map {
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
        isSaveButtonEnabled = isValid
    }
 
    func save() {
            let newHabit = HabitHistoryModel(title: habitTitle)
            dataManager.save(newHabit)
            habitTitle = ""
            fetchHabits()
        }
    
    func startHabit(id: UUID) {
        guard let habitHistory = dataManager.fetch(byID: id, HabitHistoryModel.self) else {
            return
        }

        let maxSortOrder = dataManager
            .fetchAll(HabitModel.self)
            .map(\.sortOrder)
            .max() ?? -1
        let habit = HabitModel(
            title: habitHistory.title,
            sortOrder: maxSortOrder + 1,
            iconName: habitHistory.iconName,
            frequency: habitHistory.frequency,
            commitmentDays: habitHistory.commitmentDays,
            reminderTimes: habitHistory.reminderTimes,
            customWeekdays: habitHistory.customWeekdays
        )

        dataManager.save(habit)
        dataManager.delete(byID: id, HabitHistoryModel.self)
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
        itemToDelete = id
    }
    
    func performDelete() {
        guard let id = itemToDelete else {
            return
        }
        reminderScheduler.cancelReminders(for: id)
        dataManager.delete(byID: id, HabitHistoryModel.self)
        listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        itemToDelete = nil
    }

    private func completedDate(for habit: HabitModel) -> Date {
        Calendar.current.date(byAdding: .day, value: habit.commitmentDays, to: habit.createdAt) ?? habit.createdAt
    }
    
    func dismiss() {
        coordinator.goBack()
    }
}
