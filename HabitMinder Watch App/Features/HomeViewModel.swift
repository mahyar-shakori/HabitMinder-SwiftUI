//
//  HomeViewModel.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var habits: [HabitData] = []
    
    private let sessionManager: WatchSessionManaging
    
    init(sessionManager: WatchSessionManaging) {
        self.sessionManager = sessionManager
        self.sessionManager.configure(with: self)
    }
    
    func updateHabits(_ newHabits: [HabitData]) {
        self.habits = newHabits
    }
}
