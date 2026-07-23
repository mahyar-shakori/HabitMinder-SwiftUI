//
//  HabitHistoryModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation
import SwiftData

@Model
final class HabitHistoryModel: IdentifiableModel {
    var id: UUID = UUID()
    var ownerID: String = ""
    var title: String = ""
    var createdAt: Date = Date()
    var iconName: String = SystemIconName.checkmark
    var frequency: String = L10n.AddHabitPage.frequencyDaily
    var commitmentDays: Int = 21
    var reminderTimes: [String] = []
    var customWeekdays: [Int] = []

    init(
        id: UUID = .init(),
        ownerID: String = "",
        title: String,
        createdAt: Date = .now,
        iconName: String = SystemIconName.checkmark,
        frequency: String = L10n.AddHabitPage.frequencyDaily,
        commitmentDays: Int = 21,
        reminderTimes: [String] = [],
        customWeekdays: [Int] = [Calendar.current.component(.weekday, from: Date())]
    ) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.createdAt = createdAt
        self.iconName = iconName
        self.frequency = frequency
        self.commitmentDays = commitmentDays
        self.reminderTimes = reminderTimes
        self.customWeekdays = customWeekdays
    }
}
