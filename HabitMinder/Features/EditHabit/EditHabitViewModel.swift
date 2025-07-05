//
//  EditHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

final class EditHabitViewModel: ObservableObject {
    @Published private(set) var uiState = EditHabitUIState()

    private let habitID: UUID
    private let dataManager: DataManaging
    private let coordinator: EditHabitCoordinating

    private var trimmedHabitTitle: String {
        uiState.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(
        dataManager: DataManaging,
        coordinator: EditHabitCoordinating,
        habit: HabitModel
    ) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.habitID = habit.id
        self.uiState.habitTitle = habit.title
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
        dataManager.update({ $0.title = uiState.habitTitle }, forID: habitID, HabitModel.self)
        NotificationCenter.default.post(name: AppNotification.Habit.edited, object: nil)
        coordinator.goBack()
    }
    
    func missHabit() {
        dataManager.update({ $0.createdAt = Date() }, forID: habitID, HabitModel.self)
    }
    
    func missHabitAndShowToast() {
        missHabit()
        uiState.showToast = true
        
        Task {
            await Task.delay()
            await MainActor.run {
                uiState.showToast = false
            }
        }
    }
}
