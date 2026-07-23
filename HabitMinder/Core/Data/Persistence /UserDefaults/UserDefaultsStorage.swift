//
//  UserDefaultsStorage.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class UserDefaultsStorage: UserDefaultsStoring {
    private let defaults = UserDefaults.standard
    private let legacyProfileImageDataKey = "userDefaultsStorage_ProfileImage" + "Data"

    init() {
        defaults.register(defaults: [
            UserDefaultKeys.allowNotifications.rawValue: true,
            UserDefaultKeys.dailyReminders.rawValue: true,
            UserDefaultKeys.journeyCompletionNotifications.rawValue: true,
            UserDefaultKeys.dailyQuotes.rawValue: true
        ])
    }
    
    func save<Value>(
        value: Value,
        for key: any StorageKeyProtocol
    ) {
        defaults.set(
            value,
            forKey: storageKey(for: key)
        )
    }
    
    func fetch<Value>(
        for key: any StorageKeyProtocol
    ) -> Value? {
        defaults.object(forKey: storageKey(for: key)) as? Value
    }

    func removeValue(for key: any StorageKeyProtocol) {
        defaults.removeObject(forKey: storageKey(for: key))
    }

    func removeAllAppValues() {
        UserDefaultKeys.allCases.forEach { key in
            removeValue(for: key)
            defaults.removeObject(forKey: key.rawValue)
        }
        defaults.removeObject(forKey: legacyProfileImageDataKey)
    }

    private func storageKey(for key: any StorageKeyProtocol) -> String {
        guard let userDefaultKey = key as? UserDefaultKeys,
              userDefaultKey.isAccountScoped,
              let accountID = defaults.string(forKey: UserDefaultKeys.currentAccountID.rawValue),
              accountID.isNotEmpty else {
            return key.rawValue
        }

        return "\(key.rawValue)_\(accountID)"
    }
}

private extension UserDefaultKeys {
    var isAccountScoped: Bool {
        switch self {
        case .userName,
             .userEmail,
             .userCreatedAt,
             .profileImageFileName,
             .allowNotifications,
             .dailyReminders,
             .reminderTimeMinutes,
             .dailyQuotes,
             .journeyCompletionNotifications,
             .journeyCompletionNotifiedIDs,
             .appPrimaryColor,
             .appAppearanceMode:
            return true
        case .language,
             .currentAccountID,
             .isLogin:
            return false
        }
    }
}
