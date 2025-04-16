//
//  AddHabitViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import SwiftUI

final class AddHabitViewModel: ObservableObject {
    @Published var habitTitle = "" {
        didSet {
            updateValidationState()
        }
    }
    @Published var isSaveButtonEnabled: Bool = false
    
    private let habitManager: DataManager<Habit>
    
    init(habitManager: DataManager<Habit>) {
        self.habitManager = habitManager
    }
    
    private func updateValidationState() {
        let trimmedName = habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = trimmedName.count > 1
        
        isSaveButtonEnabled = isValid
    }
    
    func save() {
        let newHabit = Habit(title: habitTitle)
        habitManager.save(newHabit)
    }
}
