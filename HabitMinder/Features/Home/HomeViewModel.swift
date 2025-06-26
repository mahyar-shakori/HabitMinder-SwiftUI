//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var uiState: HomeUIState

    private var quote: String
    private var coordinator: HomeCoordinating
    private let habitDataManager: AnyDataManager<HabitModel>
    private let futureHabitDataManager: AnyDataManager<FutureHabitModel>
    private let loginStorage: AnyUserDefaultsStorage<Bool>
    
    var displayedQuote: String {
        if quote.count > 100 {
            return LocalizedStrings.HomePage.defaultQuote
        } else {
            return quote
        }
    }
    
    init(
        quote: String,
        habitDataManager: AnyDataManager<HabitModel>,
        futureHabitDataManager: AnyDataManager<FutureHabitModel>,
        coordinator: HomeCoordinating,
        connectivityService: WatchConnectivityProviding,
        loginStorage: AnyUserDefaultsStorage<Bool>
    ) {
        self.quote = quote
        self.habitDataManager = habitDataManager
        self.futureHabitDataManager = futureHabitDataManager
        self.coordinator = coordinator
        self.uiState = HomeUIState(connectivityService: connectivityService)
        self.loginStorage = loginStorage
        
        fetchHabits()
    }
    
    func handleDropDownSelection(index: Int) {
        guard uiState.dropDownItems.indices.contains(index) else {
            return
        }
        uiState.navigationTarget = uiState.dropDownItems[index].target
    }
    
    func fetchHabits() {
        let habits = habitDataManager.fetchAll().sorted(by: { $0.sortOrder < $1.sortOrder })
        uiState.listItems = habits.map(mapToHabitItem)
    }
    
    func moveItem(
        from source: IndexSet,
        to destination: Int
    ) {
        uiState.listItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in uiState.listItems.enumerated() {
            if let habit = habitDataManager.fetch(byID: item.id) {
                habit.sortOrder = index
                habitDataManager.save(habit)
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
        habitDataManager.delete(byID: id)
        uiState.listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        uiState.itemToDelete = nil
    }
 
    func editHabit(id: UUID) {
        guard let habit = habitDataManager.fetch(byID: id) else {
            return
        }
        coordinator.goToEditHabit(habit: habit)
    }
    
    private func handleEditHabitList() {
        if uiState.listItems.isNotEmpty {
            uiState.isEditingList.toggle()
        }
    }
    
    @MainActor
    func refresh() async {
        await Task.delay()
        fetchHabits()
    }
    
    func stopEditingList() {
        uiState.isEditingList = false
    }
    
    private func setNavigationTargetEmpty() {
        uiState.navigationTarget = nil
    }
    
    func performLogout() {
        loginStorage.save(value: false)
        
        habitDataManager.deleteAll()
        futureHabitDataManager.deleteAll()
        coordinator.goToIntro()
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
