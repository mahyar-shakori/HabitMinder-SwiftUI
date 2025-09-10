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
    private let dataManager: DataManaging
    private let userDefaultsStorage: UserDefaultsStoring

    var displayedQuote: String {
        if quote.count > 100 {
            return LocalizedStrings.HomePage.defaultQuote
        } else {
            return quote
        }
    }
    
    init(
        quote: String,
        dataManager: DataManaging,
        coordinator: HomeCoordinating,
        connectivityService: WatchConnectivityProviding,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.quote = quote
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.uiState = HomeUIState(connectivityService: connectivityService)
        self.userDefaultsStorage = userDefaultsStorage

        fetchHabits()
    }
    
    func handleDropDownSelection(index: Int) {
        guard uiState.dropDownItems.indices.contains(index) else {
            return
        }
        uiState.navigationTarget = uiState.dropDownItems[index].target
    }
    
    func fetchHabits() {
        let habits: [HabitModel] = dataManager.fetchAll(HabitModel.self)
            .sorted(by: { $0.sortOrder < $1.sortOrder })
        uiState.listItems = habits.map(mapToHabitItem)
    }
    
    func moveItem(
        from source: IndexSet,
        to destination: Int
    ) {
        uiState.listItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in uiState.listItems.enumerated() {
            if let habit = dataManager.fetch(byID: item.id, HabitModel.self) {
                habit.sortOrder = index
                dataManager.save(habit)
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
        dataManager.delete(byID: id, HabitModel.self)
        uiState.listItems.removeAll { $0.id == id }
        cancelDelete()
    }
    
    func cancelDelete() {
        uiState.itemToDelete = nil
    }
    
    func editHabit(id: UUID) {
        guard let habit = dataManager.fetch(byID: id, HabitModel.self) else {
            return
        }
        coordinator.goToEditHabit(habit: habit)
    }
    
    private func handleEditHabitList() {
        if uiState.listItems.isNotEmpty {
            uiState.isEditingList.toggle()
        }
    }
    
    func stopEditingList() {
        uiState.isEditingList = false
    }
    
    private func setNavigationTargetEmpty() {
        uiState.navigationTarget = nil
    }
    
    func performLogout() {
        userDefaultsStorage.save(value: false, for: UserDefaultKeys.isLogin)
        dataManager.deleteAll(HabitModel.self)
        dataManager.deleteAll(FutureHabitModel.self)
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
