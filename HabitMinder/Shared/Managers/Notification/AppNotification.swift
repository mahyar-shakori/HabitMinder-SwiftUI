//
//  AppNotification.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation
import UserNotifications

struct AppNotification {
    struct Habit {
        static let added = Notification.Name("habitAdded")
        static let futureAdded = Notification.Name("futureHabitAdded")
        static let futureStarted = Notification.Name("futureHabitStarted")
        static let edited = Notification.Name("habitEdited")
    }
}

enum HabitNotificationAuthorizationStatus {
    case allowed
    case denied
    case notDetermined
}

protocol HabitReminderScheduling: Sendable {
    func configureForegroundPresentation()
    func getAuthorizationStatus(completion: @escaping @Sendable (HabitNotificationAuthorizationStatus) -> Void)
    func requestAuthorization(completion: @escaping @Sendable (Bool) -> Void)
    func scheduleReminders(
        for habitID: UUID,
        title: String,
        times: [String],
        frequency: HabitFrequency,
        customWeekdays: [Int]
    )
    func cancelReminders(for habitID: UUID)
}

final class HabitReminderScheduler: HabitReminderScheduling, @unchecked Sendable {
    private let center: UNUserNotificationCenter
    private let notificationDelegate = AppNotificationDelegate()

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func configureForegroundPresentation() {
        center.delegate = notificationDelegate
    }

    func getAuthorizationStatus(completion: @escaping @Sendable (HabitNotificationAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                completion(.allowed)
            case .notDetermined:
                completion(.notDetermined)
            case .denied:
                completion(.denied)
            @unknown default:
                completion(.denied)
            }
        }
    }

    func requestAuthorization(completion: @escaping @Sendable (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { isAllowed, _ in
            completion(isAllowed)
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

        requestAuthorization { [weak self] isAllowed in
            guard let self, isAllowed else {
                return
            }

            let dateComponents = uniqueTimes.flatMap {
                self.notificationDateComponents(
                    from: $0,
                    frequency: frequency,
                    customWeekdays: customWeekdays
                )
            }

            for (index, components) in dateComponents.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = "Time for your ritual."
                content.sound = .default

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: reminderIdentifier(for: habitID, index: index),
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    func cancelReminders(for habitID: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: reminderIdentifiers(for: habitID)
        )
    }

    private func notificationDateComponents(
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

    private func dateComponents(
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

    private func reminderIdentifier(for habitID: UUID, index: Int) -> String {
        "habit-reminder-\(habitID.uuidString)-\(index)"
    }

    private func reminderIdentifiers(for habitID: UUID) -> [String] {
        (0..<70).map { reminderIdentifier(for: habitID, index: $0) }
    }
}

private final class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
}
