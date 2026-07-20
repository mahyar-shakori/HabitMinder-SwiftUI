//
//  FutureHabitUIState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

struct FutureHabitUIState {
    var isSaveButtonEnabled = false
    var listItems: [FutureHabitItem] = []
    var completedItems: [CompletedHabitItem] = []
    var itemToDelete: UUID?
}

struct CompletedHabitItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let completedAt: Date
    let iconName: String
    let commitmentDays: Int
}
