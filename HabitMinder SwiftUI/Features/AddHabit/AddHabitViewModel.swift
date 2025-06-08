//
//  AddHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation

final class AddHabitViewModel: ObservableObject {
    @Published private(set) var uiState = AddHabitUIState()

    private let habitManager: DataManager<HabitModel>
    private let coordinator: AddHabitCoordinator
    
    private var trimmedHabitTitle: String {
        uiState.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(
        habitManager: DataManager<HabitModel>,
        coordinator: AddHabitCoordinator
    ) {
        self.habitManager = habitManager
        self.coordinator = coordinator
    }
    
    func setHabitTitle(_ newValue: String) {
        uiState.habitTitle = newValue
        updateValidationState()
    }
    
    private func updateValidationState() {
        let isValid = trimmedHabitTitle.count > 0
        uiState.isSaveButtonEnabled = isValid
    }
    
    func saveAndDismiss() {
        let maxSortOrder = habitManager.fetchAll().map(\.sortOrder).max() ?? -1

        let newHabit = HabitModel(
            title: trimmedHabitTitle,
            sortOrder: maxSortOrder + 1
        )
        
        habitManager.save(newHabit)
        NotificationCenter.default.post(name: AppNotification.Habit.added, object: nil)
        coordinator.goBack()
    }
}
