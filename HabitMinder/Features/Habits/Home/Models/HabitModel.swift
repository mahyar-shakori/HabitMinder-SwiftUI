//
//  HabitModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import SwiftData

@Model
final class HabitModel: IdentifiableModel {
    var id: UUID = UUID()
    var ownerID: String = ""
    var title: String = ""
    var createdAt: Date = Date()
    var sortOrder: Int = 0
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
        sortOrder: Int = 0,
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
        self.sortOrder = sortOrder
        self.iconName = iconName
        self.frequency = frequency
        self.commitmentDays = commitmentDays
        self.reminderTimes = reminderTimes
        self.customWeekdays = customWeekdays
    }
}
