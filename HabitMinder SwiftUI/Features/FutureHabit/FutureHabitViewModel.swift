//
//  FutureHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class FutureHabitViewModel: ObservableObject {
    @Published private(set) var uiState = FutureHabitUIState()
    
    private let habitManager: DataManager<FutureHabitModel>
    private let coordinator: FutureHabitCoordinator
    
    private var trimmedHabitTitle: String {
        uiState.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(
        habitManager: DataManager<FutureHabitModel>,
        coordinator: FutureHabitCoordinator
    ) {
        self.habitManager = habitManager
        self.coordinator = coordinator
        fetchHabits()
    }
    
    func setHabitTitle(_ newValue: String) {
        uiState.habitTitle = newValue
        updateValidationState()
    }
    
    func fetchHabits() {
        let models = habitManager.fetchAll()
        uiState.listItems = models.map {
            FutureHabitItem(
                id: $0.id,
                title: $0.title,
                dateCreate: $0.createdAt
            )
        }
    }
    
    private func updateValidationState() {
        let isValid = trimmedHabitTitle.count > 0
        uiState.isSaveButtonEnabled = isValid
    }
    
    func save() {
        let newHabit = FutureHabitModel(title: uiState.habitTitle)
        habitManager.save(newHabit)
        uiState.habitTitle = ""
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
    
    func dismiss() {
        coordinator.goBack()
    }
}
