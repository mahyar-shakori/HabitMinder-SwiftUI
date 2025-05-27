//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var isDropDownPresented = false
    @Published var navigationTarget: HomeNavigationTarget?
    @Published var isEditingList = false
    @Published var listItems: [HabitItem] = []
    @Published var showDeleteAlert: Bool = false
    @Published var showEditAlert: Bool = false
    @Published var showListEmptyAlert: Bool = false
    
    private(set) var itemToDelete: UUID?
    private(set) var itemToEdit: UUID?
    private let habitManager: DataManager<HabitModel>
    let quote: String
    
    let dropDownItems = [
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.addNewHabit,
            imageName: .addNewHabit,
            target: .addHabit
        ),
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.editHabitList,
            imageName: .editHabitList,
            target: .editHabitList
        ),
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.rename,
            imageName: .rename,
            target: .rename
        )
    ]
    
    init(quote: String, habitManager: DataManager<HabitModel>) {
        self.quote = quote
        self.habitManager = habitManager
        fetchHabits()
    }
    
    func handleDropDownSelection(index: Int) {
        guard dropDownItems.indices.contains(index) else {
            return
        }
        navigationTarget = dropDownItems[index].target
        isDropDownPresented = false
    }
    
    // back tread
    func fetchHabits() {
        let habits = habitManager.fetchAll()
        listItems = habits.map(mapToHabitItem)
        sendHabitsToWatch()
    }
    
    
    // in 2 func yeki beshan
    // struct beshe
    // tuple memory issue dare
    private func mapToHabitItem(_ habit: HabitModel) -> HabitItem {
        let (daysLeft, progress) = calculateProgress(for: habit)
        return HabitItem(id: habit.id, title: habit.title, daysLeft: daysLeft, progress: progress)
    }
    
    private func calculateProgress(for habit: HabitModel) -> (daysLeft: Int, progress: Double) {
        let daysLeft = habit.createdAt.habitDaysCountSinceCreation(for: habit.id)
        let progress = Double(22 - daysLeft) / 22.0
        return (daysLeft, progress)
    }
    
    func handleEditHabitList() {
        showListEmptyAlert = listItems.isEmpty
        if listItems.isNotEmpty {
            isEditingList.toggle()
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        listItems.move(fromOffsets: source, toOffset: destination)
    }
    
    @MainActor
    func refresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        fetchHabits()
    }
    
    func confirmDelete(id: UUID) {
        itemToDelete = id
        showDeleteAlert = true
    }
    
    // send habit to watch mutable state
    // syncronize konin vaghti ye operation anjam mishe vaysta un tamum she bad baadi shuru kon
    
    func performDelete() {
        guard let id = itemToDelete else {
            return
        }
        habitManager.delete(byID: id)
        listItems.removeAll { $0.id == id }
        resetDeleteState()
        sendHabitsToWatch()
    }
    
    private func resetDeleteState() {
        itemToDelete = nil
        showDeleteAlert = false
    }
    
    func confirmEdit(id: UUID) {
        itemToEdit = id
        showEditAlert = true
    }
    
    func performEdit() {
        guard let id = itemToEdit else {
            return
        }
        habitManager.update({ $0.createdAt = Date() }, forID: id)
        fetchHabits()
        resetEditState()
        sendHabitsToWatch()
    }
    
    private func resetEditState() {
        itemToEdit = nil
        showEditAlert = false
    }
    
    
    // reactive chain a depende b bash masalan be jaye inke bgi a call she b call she
    private func sendHabitsToWatch() {
        let habitsToSend = listItems.map { $0.toWatchHabit }
        WatchConnectivityService.shared.sendHabits(habitsToSend)
    }
}
