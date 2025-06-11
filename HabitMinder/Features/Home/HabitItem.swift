//
//  HabitItem.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation

struct HabitItem: Identifiable {
    let id: UUID
    let title: String
    let daysLeft: Int
    let progress: Double
}

extension HabitItem {
    var toWatchHabit: HabitData {
        HabitData(title: self.title, daysLeft: self.daysLeft)
    }
}
