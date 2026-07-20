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
    var itemToDelete: UUID?
}
