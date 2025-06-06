//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var uiState = HomeUIState()
    
    private(set) var quote: String
    private(set) var coordinator: HomeCoordinator
    private let habitManager: DataManager<HabitModel>
    private let futureHabitManager: DataManager<FutureHabitModel>
    
    init(
        quote: String,
        habitManager: DataManager<HabitModel>,
        futureHabitManager: DataManager<FutureHabitModel>,
        coordinator: HomeCoordinator
    ) {
        self.quote = quote
        self.habitManager = habitManager
        self.futureHabitManager = futureHabitManager
        self.coordinator = coordinator
        
        fetchHabits()
    }
    
    func handleDropDownSelection(index: Int) {
        guard uiState.dropDownItems.indices.contains(index) else {
            return
        }
        uiState.navigationTarget = uiState.dropDownItems[index].target
    }
    
    func fetchHabits() {
        let habits = habitManager.fetchAll().sorted(by: { $0.sortOrder < $1.sortOrder })
        uiState.listItems = habits.map(mapToHabitItem)
    }
    
    func moveItem(
        from source: IndexSet,
        to destination: Int
    ) {
        uiState.listItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in uiState.listItems.enumerated() {
            if let habit = habitManager.fetch(byID: item.id) {
                habit.sortOrder = index
                habitManager.save(habit)
            }
        }
    }
    
    func confirmDelete(id: UUID) {
        uiState.itemToDelete = id
    }
    
    func performDelete() {
        guard let id = uiState.itemToDelete else {
            return
        }
        habitManager.delete(byID: id)
        uiState.listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        uiState.itemToDelete = nil
    }
    
    func confirmEdit(id: UUID) -> HabitModel? {
        return habitManager.fetch(byID: id)
    }
    
    private func handleEditHabitList() {
        if uiState.listItems.isNotEmpty {
            uiState.isEditingList.toggle()
        }
    }
    
    @MainActor
    func refresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        fetchHabits()
    }
    
    func stopEditingList() {
        uiState.isEditingList = false
    }
    
    private func setNavigationTargetEmpty() {
        uiState.navigationTarget = nil
    }
    
    func performLogout() {
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        loginStorage.save(value: false)
        
        habitManager.deleteAll()
        futureHabitManager.deleteAll()
        coordinator.goToSetLanguage()
    }
    
    func resetLogoutAlert() {
        uiState.performLogoutAlert = false
    }
    
    func handleNavigation(_ target: HomeNavigationTarget?) {
        guard let target else { return }
        switch target {
        case .addHabit:
            coordinator.goToAddHabit()
        case .futureHabit:
            coordinator.goToFutureHabit()
        case .editHabitList:
            if uiState.listItems.isNotEmpty {
                handleEditHabitList()
            }
        case .setting:
            coordinator.goToSetting()
        case .logout:
            uiState.performLogoutAlert = true
        }
        setNavigationTargetEmpty()
    }
    
    private func mapToHabitItem(_ habit: HabitModel) -> HabitItem {
        let daysLeft = habit.createdAt.habitDaysCountSinceCreation(for: habit.id)
        let progress = Double(22 - daysLeft) / 22.0
        return HabitItem(
            id: habit.id,
            title: habit.title,
            daysLeft: daysLeft,
            progress: progress
        )
    }
}
