//
//  HabitReminderScheduler.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation
import UserNotifications

final class HabitReminderScheduler: HabitReminderScheduling {
    private let center: UNUserNotificationCenter
    private let notificationDelegate = AppNotificationDelegate()

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func configureForegroundPresentation() {
        center.delegate = notificationDelegate
    }

    func getAuthorizationStatus(completion: @escaping @MainActor @Sendable (HabitNotificationAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            let status: HabitNotificationAuthorizationStatus

            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                status = .allowed
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .denied
            @unknown default:
                status = .denied
            }

            Task { @MainActor in
                completion(status)
            }
        }
    }

    func requestAuthorization(completion: @escaping @MainActor @Sendable (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { isAllowed, _ in
            Task { @MainActor in
                completion(isAllowed)
            }
        }
    }

    func scheduleReminders(
        for habitID: UUID,
        title: String,
        times: [String],
        frequency: HabitFrequency,
        customWeekdays: [Int] = []
    ) {
        cancelReminders(for: habitID)

        let uniqueTimes = Array(Set(times)).sorted()
        guard uniqueTimes.isNotEmpty else {
            return
        }

        let dateComponents = uniqueTimes.flatMap {
            Self.notificationDateComponents(
                from: $0,
                frequency: frequency,
                customWeekdays: customWeekdays
            )
        }

        requestAuthorization { isAllowed in
            guard isAllowed else {
                return
            }

            for (index, components) in dateComponents.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = L10n.Notification.habitReminderBody
                content.sound = .default

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: Self.reminderIdentifier(for: habitID, index: index),
                    content: content,
                    trigger: trigger
                )
                UNUserNotificationCenter.current().add(request)
            }
        }
    }

    func cancelReminders(for habitID: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: Self.reminderIdentifiers(for: habitID)
        )
    }

    private static func notificationDateComponents(
        from time: String,
        frequency: HabitFrequency,
        customWeekdays: [Int]
    ) -> [DateComponents] {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else {
            return []
        }

        let hour = parts[0]
        let minute = parts[1]

        switch frequency {
        case .daily:
            return [dateComponents(hour: hour, minute: minute)]
        case .weekly:
            let weekday = Calendar.current.component(.weekday, from: .now)
            return [dateComponents(hour: hour, minute: minute, weekday: weekday)]
        case .custom:
            return customWeekdays
                .filter { (1...7).contains($0) }
                .map { dateComponents(hour: hour, minute: minute, weekday: $0) }
        }
    }

    private static func dateComponents(
        hour: Int,
        minute: Int,
        weekday: Int? = nil
    ) -> DateComponents {
        var components = DateComponents()
        components.calendar = .current
        components.timeZone = .current
        components.hour = hour
        components.minute = minute
        components.weekday = weekday
        return components
    }

    private static func reminderIdentifier(for habitID: UUID, index: Int) -> String {
        "habit-reminder-\(habitID.uuidString)-\(index)"
    }

    private static func reminderIdentifiers(for habitID: UUID) -> [String] {
        (0..<70).map { reminderIdentifier(for: habitID, index: $0) }
    }
}
