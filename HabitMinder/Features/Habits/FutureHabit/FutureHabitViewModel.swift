//
//  FutureHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class FutureHabitViewModel: ObservableObject {
    @Published private(set) var uiState = FutureHabitUIState()
    
    private let dataManager: DataManaging
    private let coordinator: FutureHabitCoordinating
    private var habitTitle = ""
    
    private var trimmedHabitTitle: String {
        habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(
        dataManager: DataManaging,
        coordinator: FutureHabitCoordinating
    ) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        fetchHabits()
    }
    
    func setHabitTitle(_ newValue: String) {
        habitTitle = newValue
        updateValidationState()
    }
   
    func fetchHabits() {
            let models: [FutureHabitModel] = dataManager.fetchAll(FutureHabitModel.self)
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
            let newHabit = FutureHabitModel(title: habitTitle)
            dataManager.save(newHabit)
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
        dataManager.delete(byID: id, FutureHabitModel.self)
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
