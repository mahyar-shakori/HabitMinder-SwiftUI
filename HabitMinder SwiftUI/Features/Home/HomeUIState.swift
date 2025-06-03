//
//  HomeUIState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

struct HomeUIState {
    var isEditingList = false
    var itemToDelete: UUID?
    var navigationTarget: HomeNavigationTarget?
    
    var listItems: [HabitItem] = [] {
        didSet {
            let habitsToSend = listItems.map { $0.toWatchHabit }
            WatchConnectivityService.shared.sendHabits(habitsToSend)
        }
    }
}
