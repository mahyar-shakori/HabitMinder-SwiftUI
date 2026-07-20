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
            return L10n.AddHabitPage.frequencyDaily
        case .weekly:
            return L10n.AddHabitPage.frequencyWeekly
        case .custom:
            return L10n.AddHabitPage.frequencyCustom
        }
    }
}

struct AddHabitUIState {
    var habitTitle = ""
    var selectedIconName = ""
    var selectedFrequency = HabitFrequency.daily
    var selectedCustomWeekdays = [Calendar.current.component(.weekday, from: Date())]
    var commitmentDays = 21
    var reminderTimes: [String] = []
    var isFutureHabit = false
    var isSaveButtonEnabled = false
    var isNotificationSettingsAlertPresented = false
}
