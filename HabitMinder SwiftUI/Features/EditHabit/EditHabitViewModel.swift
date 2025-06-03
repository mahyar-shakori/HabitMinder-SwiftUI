//
//  EditHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

final class EditHabitViewModel: ObservableObject {
    @Published var habitTitle = "" {
        didSet { updateValidationState() }
    }
    @Published private(set) var isSaveButtonEnabled = false
    
    private let habit: HabitModel
    private let dataManager: DataManager<HabitModel>
    private let habitID: UUID
    
    init(habit: HabitModel, dataManager: DataManager<HabitModel>) {
        self.habit = habit
        self.habitTitle = habit.title
        self.habitID = habit.id
        self.dataManager = dataManager
        updateValidationState()
    }
    
    private func updateValidationState() {
        let trimmedName = habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = trimmedName.count > 1
        
        isSaveButtonEnabled = isValid
    }
    
    func save() {
        dataManager.update({ $0.title = habitTitle }, forID: habitID)
    }
    
    func missHabit() {
        dataManager.update({ $0.createdAt = Date() }, forID: habitID)
    }
    
    func postHabitEditedNotification() {
        NotificationCenter.default.post(name: AppNotification.Habit.edited, object: nil)
    }
}
