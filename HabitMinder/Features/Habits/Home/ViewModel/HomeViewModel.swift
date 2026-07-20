//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
    private(set) var isEditingList = false
    private(set) var itemToDelete: UUID?
    private let connectivityService: WatchConnectivityProviding
    private let reminderScheduler: HabitReminderScheduling
    private var quote: String
    private var author: String
    private var coordinator: HomeCoordinating
    private let dataManager: DataManaging
    private let userDefaultsStorage: UserDefaultsStoring

    var listItems: [HabitItem] = [] {
        didSet {
            let habitsToSend = listItems.map { $0.toWatchHabit }
            connectivityService.sendHabits(habitsToSend)
        }
    }

    var displayedQuote: String {
        shouldUseDefaultQuote ? L10n.HomePage.defaultQuote : quote
    }

    var displayedAuthor: String {
        let displayedAuthor = shouldUseDefaultQuote ? L10n.HomePage.defaultAuthor : author
        return displayedAuthor.isEmpty ? String() : L10n.HomePage.author(displayedAuthor)
    }

    var deleteConfirmationMessage: String {
        guard let itemToDelete,
              let title = listItems.first(where: { $0.id == itemToDelete })?.title else {
            return L10n.Alert.Habit.deleteMessage
        }

        return L10n.Alert.Habit.deleteMessage(title: title)
    }

    private var shouldUseDefaultQuote: Bool {
        quote.count > LayoutCount.quoteCharacterLimit || quote.isEmpty
    }
    
    init(
        quote: String,
        author: String,
        dataManager: DataManaging,
        coordinator: HomeCoordinating,
        connectivityService: WatchConnectivityProviding,
        userDefaultsStorage: UserDefaultsStoring,
        reminderScheduler: HabitReminderScheduling
    ) {
        self.quote = quote
        self.author = author
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.connectivityService = connectivityService
        self.userDefaultsStorage = userDefaultsStorage
        self.reminderScheduler = reminderScheduler

        fetchHabits()
    }
    
    func fetchHabits() {
        let allHabits: [HabitModel] = dataManager.fetchAll(HabitModel.self)
        allHabits
            .filter { $0.createdAt.habitDaysCountSinceCreation(for: $0.id, totalDays: $0.commitmentDays) == 0 }
            .forEach { reminderScheduler.cancelReminders(for: $0.id) }

        let habits = allHabits
            .filter { $0.createdAt.habitDaysCountSinceCreation(for: $0.id, totalDays: $0.commitmentDays) > 0 }
            .sorted(by: { $0.sortOrder < $1.sortOrder })
        listItems = habits.map(mapToHabitItem)
    }
    
    func moveItem(
        from source: IndexSet,
        to destination: Int
    ) {
        listItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in listItems.enumerated() {
            if let habit = dataManager.fetch(byID: item.id, HabitModel.self) {
                habit.sortOrder = index
                dataManager.save(habit)
            }
        }
    }
    
    func confirmDelete(id: UUID) {
        itemToDelete = id
    }
    
    func performDelete() {
        guard let id = itemToDelete else {
            return
        }
        reminderScheduler.cancelReminders(for: id)
        dataManager.delete(byID: id, HabitModel.self)
        listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        itemToDelete = nil
    }
    
    func editHabit(id: UUID) {
        coordinator.goToEditHabit(id: id)
    }
    
    func goToAddHabitPage() {
        coordinator.goToAddHabit()
    }

    private func mapToHabitItem(_ habit: HabitModel) -> HabitItem {
        let commitmentDays = max(1, habit.commitmentDays)
        let daysLeft = habit.createdAt.habitDaysCountSinceCreation(for: habit.id, totalDays: commitmentDays)
        let progress = Double(commitmentDays - daysLeft) / Double(commitmentDays)
        return HabitItem(
            id: habit.id,
            title: habit.title,
            daysLeft: daysLeft,
            progress: progress,
            iconName: habit.iconName,
            commitmentDays: commitmentDays
        )
    }
}
