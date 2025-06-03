//
//  AddHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation

final class AddHabitViewModel: ObservableObject {
    @Published var habitTitle = "" {
        didSet { updateValidationState() }
    }
    @Published private(set) var isSaveButtonEnabled = false
    
    private let habitManager: DataManager<HabitModel>
    
    init(habitManager: DataManager<HabitModel>) {
        self.habitManager = habitManager
    }
    
    private func updateValidationState() {
        let trimmedName = habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = trimmedName.count > 1
        
        isSaveButtonEnabled = isValid
    }
    
    func save() {
        let newHabit = HabitModel(title: habitTitle)
        habitManager.save(newHabit)
    }
    
    func postHabitAddedNotification() {
        NotificationCenter.default.post(name: AppNotification.Habit.added, object: nil)
    }
}
