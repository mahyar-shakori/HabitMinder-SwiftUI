//
//  HabitReminderScheduling.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation

@MainActor
protocol HabitReminderScheduling {
    var areDailyRemindersEnabled: Bool { get }

    func configureForegroundPresentation()
    func getAuthorizationStatus(completion: @escaping @MainActor @Sendable (HabitNotificationAuthorizationStatus) -> Void)
    func requestAuthorization(completion: @escaping @MainActor @Sendable (Bool) -> Void)
    func scheduleReminders(
        for habitID: UUID,
        title: String,
        times: [String],
        frequency: HabitFrequency,
        customWeekdays: [Int]
    )
    func scheduleJourneyCompletion(for habitID: UUID, title: String)
    func cancelReminders(for habitID: UUID)
    func cancelDailyReminders()
    func cancelAllNotifications()
}
