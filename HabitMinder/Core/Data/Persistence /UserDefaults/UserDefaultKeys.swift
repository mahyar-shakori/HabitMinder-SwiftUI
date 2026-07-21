//
//  UserDefaultKeys.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum UserDefaultKeys: String, StorageKeyProtocol, CaseIterable {
    case language = "userDefaultsStorage_Language"
    case userName = "userDefaultsStorage_UserName"
    case isLogin = "userDefaultsStorage_IsLogin"
    case userCreatedAt = "userDefaultsStorage_UserCreatedAt"
    case profileImageFileName = "userDefaultsStorage_ProfileImageFileName"
    case allowNotifications = "userDefaultsStorage_AllowNotifications"
    case dailyReminders = "userDefaultsStorage_DailyReminders"
    case reminderTimeMinutes = "userDefaultsStorage_ReminderTimeMinutes"
    case dailyQuotes = "userDefaultsStorage_DailyQuotes"
    case journeyCompletionNotifications = "userDefaultsStorage_JourneyCompletionNotifications"
    case journeyCompletionNotifiedIDs = "userDefaultsStorage_JourneyCompletionNotifiedIDs"
    case appPrimaryColor = "userDefaultsStorage_AppPrimaryColor"
    case appAppearanceMode = "userDefaultsStorage_AppAppearanceMode"
}
