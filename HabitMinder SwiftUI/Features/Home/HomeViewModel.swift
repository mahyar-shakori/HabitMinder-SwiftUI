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
    let quote: String
   
    var dropDownItems: [DropDownItem] {
            DropDownItemFactory.makeItems(for: uiState)
        }
    
    init(quote: String, habitManager: DataManager<HabitModel>) {
        self.quote = quote
        self.habitManager = habitManager
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
        let habits = habitManager.fetchAll()
        uiState.listItems = habits.map(mapToHabitItem)
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
    
    func moveItem(from source: IndexSet, to destination: Int) {
        uiState.listItems.move(fromOffsets: source, toOffset: destination)
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
    
    func confirmEdit(id: UUID) {
        uiState.itemToEdit = id
    }
    
    func performEdit() {
        guard let id = uiState.itemToEdit else {
            return
        }
        habitManager.update({ $0.createdAt = Date() }, forID: id)
        fetchHabits()
        cancelEdit()
    }
    
    func cancelEdit() {
        uiState.itemToEdit = nil
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
