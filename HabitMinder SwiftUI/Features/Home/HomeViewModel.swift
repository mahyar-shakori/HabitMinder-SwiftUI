//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var uiState = HomeUIState()
    @Published var isDropDownPresented = false

    private let habitManager: DataManager<HabitModel>
    private let futureHabitManager: DataManager<FutureHabitModel>
    let quote: String
   
    var dropDownItems: [DropDownItem] {
        DropDownItemFactory.makeItems(for: uiState)
    }
    
    init(quote: String, habitManager: DataManager<HabitModel>, futureHabitManager: DataManager<FutureHabitModel>) {
        self.quote = quote
        self.habitManager = habitManager
        self.futureHabitManager = futureHabitManager
        fetchHabits()
    }
   
    func handleDropDownSelection(index: Int) {
        guard dropDownItems.indices.contains(index) else {
            return
        }
        uiState.navigationTarget = dropDownItems[index].target
        isDropDownPresented = false
    }
 
    func fetchHabits() {
        let habits = habitManager.fetchAll().sorted(by: { $0.sortOrder < $1.sortOrder })
        uiState.listItems = habits.map(mapToHabitItem)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        uiState.listItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in uiState.listItems.enumerated() {
            if let habit = habitManager.fetch(byID: item.id) {
                habit.sortOrder = index
                habitManager.save(habit)
            }
        }
    }
  
    private func mapToHabitItem(_ habit: HabitModel) -> HabitItem {
        let progress = calculateHabitProgress(for: habit)
        return HabitItem(id: habit.id, title: habit.title, daysLeft: progress.daysLeft, progress: progress.progress)
    }

    private func calculateHabitProgress(for habit: HabitModel) -> HabitProgress {
        let daysLeft = habit.createdAt.habitDaysCountSinceCreation(for: habit.id)
        let progress = Double(22 - daysLeft) / 22.0
        return HabitProgress(daysLeft: daysLeft, progress: progress)
    }
    
    func handleEditHabitList() {
        if uiState.listItems.isNotEmpty {
            uiState.isEditingList.toggle()
        }
    }

    @MainActor
    func refresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        fetchHabits()
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
    
    func performLogout() {
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        loginStorage.save(value: false)
        
        habitManager.deleteAll()
        futureHabitManager.deleteAll()
    }
   
    func stopEditingList() {
        uiState.isEditingList = false
    }
    
    func startDropDownPresenting() {
        isDropDownPresented = true
    }
    
    func setNavigationTargetEmpty() {
        uiState.navigationTarget = nil
    }
}
