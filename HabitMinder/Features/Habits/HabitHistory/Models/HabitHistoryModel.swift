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
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    var iconName: String
    var frequency: String
    var commitmentDays: Int
    var reminderTimes: [String]
    var customWeekdays: [Int]

    init(
        id: UUID = .init(),
        title: String,
        createdAt: Date = .now,
        iconName: String = SystemIconName.checkmark,
        frequency: String = L10n.AddHabitPage.frequencyDaily,
        commitmentDays: Int = 21,
        reminderTimes: [String] = [],
        customWeekdays: [Int] = [Calendar.current.component(.weekday, from: Date())]
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.iconName = iconName
        self.frequency = frequency
        self.commitmentDays = commitmentDays
        self.reminderTimes = reminderTimes
        self.customWeekdays = customWeekdays
    }
}
