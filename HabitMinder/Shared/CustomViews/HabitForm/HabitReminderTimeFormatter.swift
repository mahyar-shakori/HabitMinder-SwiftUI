//
//  HabitReminderTimeFormatter.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import Foundation

enum HabitReminderTimeFormatter {
    static func storageTime(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        return [paddedTimeComponent(hour), paddedTimeComponent(minute)]
            .joined(separator: HabitFormConstants.DateFormat.separator)
    }

    static func displayTime(from storageTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = HabitFormConstants.DateFormat.storageTime

        guard let date = formatter.date(from: storageTime) else {
            return storageTime
        }

        formatter.dateFormat = HabitFormConstants.DateFormat.displayTime
        return formatter.string(from: date)
    }

    private static func paddedTimeComponent(_ value: Int) -> String {
        let valueText = value.description
        guard value < HabitFormConstants.DateFormat.paddedComponentThreshold else {
            return valueText
        }

        return HabitFormConstants.DateFormat.zeroPrefix + valueText
    }
}
