//
//  AppNotificationDelegate.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 21/07/2026.
//

import UserNotifications

final class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
}
