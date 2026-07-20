//
//  AddHabitUIState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 06/06/2025.
//

import Foundation

enum HabitFrequency: String, CaseIterable {
    case daily
    case weekly
    case custom

    var title: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .custom:
            return "Custom"
        }
    }
}

struct AddHabitUIState {
    var habitTitle = ""
    var selectedIconName = "book"
    var selectedFrequency = HabitFrequency.daily
    var selectedCustomWeekdays = [Calendar.current.component(.weekday, from: Date())]
    var commitmentDays = 21
    var reminderTimes: [String] = []
    var isFutureHabit = false
    var isSaveButtonEnabled = false
    var isNotificationSettingsAlertPresented = false
}
