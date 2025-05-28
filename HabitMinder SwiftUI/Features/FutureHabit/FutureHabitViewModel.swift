//
//  FutureHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class FutureHabitViewModel: ObservableObject {
    @Published var habitTitle: String = "" {
        didSet { updateValidationState() }
    }
    @Published private(set) var uiState = FutureHabitUIState()
    
    private let habitManager: DataManager<FutureHabitModel>
    
    init(habitManager: DataManager<FutureHabitModel>) {
        self.habitManager = habitManager
    }
    
    func fetchHabits() {
        let models = habitManager.fetchAll()
        uiState.listItems = models.map { FutureHabitItem(id: $0.id, title: $0.title, dateCreate: $0.createdAt) }
    }
    
    private func updateValidationState() {
        let trimmedName = habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = trimmedName.count > 1
        
        uiState.isSaveButtonEnabled = isValid
    }
    
    func save() {
        let newHabit = FutureHabitModel(title: habitTitle)
        habitManager.save(newHabit)
        habitTitle = ""
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
}
