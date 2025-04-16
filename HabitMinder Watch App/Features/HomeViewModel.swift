//
//  HomeViewModel.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var habits: [HabitData] = []

    func updateHabits(_ newHabits: [HabitData]) {
        self.habits = newHabits
    }
}
