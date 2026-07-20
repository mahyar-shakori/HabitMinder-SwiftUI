//
//  EditHabitUIState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 06/06/2025.
//

import Foundation

struct EditHabitUIState {
    var habitTitle = ""
    var selectedIconName = "book"
    var selectedFrequency = HabitFrequency.daily
    var selectedCustomWeekdays = [Calendar.current.component(.weekday, from: Date())]
    var commitmentDays = 21
    var reminderTimes: [String] = []
    var isSaveButtonEnabled = false
    var isNotificationSettingsAlertPresented = false
    var showToast = false
}
