//
//  AppNotification.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation

struct AppNotification {
    struct Settings {
        static let updated = Notification.Name("settingsUpdated")
    }

    struct Profile {
        static let updated = Notification.Name("profileUpdated")
    }

    struct Habit {
        static let added = Notification.Name("habitAdded")
        static let futureAdded = Notification.Name("futureHabitAdded")
        static let futureStarted = Notification.Name("futureHabitStarted")
        static let edited = Notification.Name("habitEdited")
    }
}
