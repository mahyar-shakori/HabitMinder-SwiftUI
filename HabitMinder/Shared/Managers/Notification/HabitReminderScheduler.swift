//
//  HabitReminderScheduler.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation
import UserNotifications

@MainActor
final class HabitReminderScheduler: HabitReminderScheduling {
    private let center: UNUserNotificationCenter
    private let notificationDelegate = AppNotificationDelegate()
    private let userDefaultsStorage: UserDefaultsStoring

    init(
        center: UNUserNotificationCenter = .current(),
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.center = center
        self.userDefaultsStorage = userDefaultsStorage
    }

    var areDailyRemindersEnabled: Bool {
        isNotificationEnabled(UserDefaultKeys.dailyReminders)
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

        guard isNotificationEnabled(UserDefaultKeys.dailyReminders) else {
            return
        }

        let uniqueTimes = Array(Set(times)).sorted()
        guard uniqueTimes.isNotEmpty else {
            return
        }

        let center = center
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
                content.title = L10n.Notification.habitReminderTitle
                content.body = L10n.Notification.habitReminderBody(title)
                content.sound = .default

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: Self.reminderIdentifier(for: habitID, index: index),
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    func scheduleJourneyCompletion(for habitID: UUID, title: String) {
        guard isNotificationEnabled(UserDefaultKeys.journeyCompletionNotifications),
              hasSentJourneyCompletion(for: habitID).not else {
            return
        }

        let center = center
        requestAuthorization { [weak self] isAllowed in
            guard isAllowed else {
                return
            }

            let content = UNMutableNotificationContent()
            content.title = L10n.Notification.journeyCompletionTitle
            content.body = L10n.Notification.journeyCompletionBody(title)
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(
                identifier: Self.journeyCompletionIdentifier(for: habitID),
                content: content,
                trigger: trigger
            )
            center.add(request)
            self?.markJourneyCompletionSent(for: habitID)
        }
    }

    func cancelReminders(for habitID: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: Self.reminderIdentifiers(for: habitID)
        )
    }

    func cancelDailyReminders() {
        center.getPendingNotificationRequests { [weak self] requests in
            let identifiers = requests
                .map(\.identifier)
                .filter { $0.hasPrefix("habit-reminder-") }

            Task { @MainActor in
                self?.center.removePendingNotificationRequests(withIdentifiers: identifiers)
            }
        }
    }

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    private func isNotificationEnabled(_ specificKey: UserDefaultKeys) -> Bool {
        let allowsNotifications: Bool = userDefaultsStorage.fetch(for: UserDefaultKeys.allowNotifications) ?? true
        let isSpecificNotificationEnabled: Bool = userDefaultsStorage.fetch(for: specificKey) ?? true
        return allowsNotifications && isSpecificNotificationEnabled
    }

    private func hasSentJourneyCompletion(for habitID: UUID) -> Bool {
        let sentIDs: [String] = userDefaultsStorage.fetch(for: UserDefaultKeys.journeyCompletionNotifiedIDs) ?? []
        return sentIDs.contains(habitID.uuidString)
    }

    private func markJourneyCompletionSent(for habitID: UUID) {
        var sentIDs: [String] = userDefaultsStorage.fetch(for: UserDefaultKeys.journeyCompletionNotifiedIDs) ?? []
        guard sentIDs.contains(habitID.uuidString).not else {
            return
        }

        sentIDs.append(habitID.uuidString)
        userDefaultsStorage.save(value: sentIDs, for: UserDefaultKeys.journeyCompletionNotifiedIDs)
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

    private static var reminderIdentifierPrefix: String {
        "habit-reminder-"
    }

    private static func reminderIdentifier(for habitID: UUID, index: Int) -> String {
        "\(reminderIdentifierPrefix)\(habitID.uuidString)-\(index)"
    }

    private static func reminderIdentifiers(for habitID: UUID) -> [String] {
        (0..<70).map { reminderIdentifier(for: habitID, index: $0) }
    }

    private static func journeyCompletionIdentifier(for habitID: UUID) -> String {
        "journey-completion-\(habitID.uuidString)"
    }
}
