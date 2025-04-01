//
//  Date+DayCounter.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/14/25.
//

import Foundation

extension Date {
    func habitDaysCountSinceCreation(for id: Int) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        guard let next21Days = calendar.date(byAdding: .day, value: 22, to: self) else {
            return 0
        }
        let diffInDays = calendar.dateComponents([.day], from: now, to: next21Days).day ?? 0
        let newDaysCount = max(diffInDays, 0)
        
        return newDaysCount
    }
}
