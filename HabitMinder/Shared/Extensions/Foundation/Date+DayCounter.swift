//
//  Date+DayCounter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation

extension Date {
    func habitDaysCountSinceCreation(for id: UUID) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let days = calendar.dateComponents([.day], from: self, to: now).day ?? 0
        return max(0, 21 - days)
    }
}
