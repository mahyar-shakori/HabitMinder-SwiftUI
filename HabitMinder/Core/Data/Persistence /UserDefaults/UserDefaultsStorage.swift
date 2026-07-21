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
            forKey: key.rawValue
        )
    }
    
    func fetch<Value>(
        for key: any StorageKeyProtocol
    ) -> Value? {
        defaults.object(forKey: key.rawValue) as? Value
    }

    func removeValue(for key: any StorageKeyProtocol) {
        defaults.removeObject(forKey: key.rawValue)
    }

    func removeAllAppValues() {
        UserDefaultKeys.allCases.forEach { key in
            removeValue(for: key)
        }
        defaults.removeObject(forKey: legacyProfileImageDataKey)
    }
}
