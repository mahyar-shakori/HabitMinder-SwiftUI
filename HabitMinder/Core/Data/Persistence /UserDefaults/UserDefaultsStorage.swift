//
//  UserDefaultsStorage.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class UserDefaultsStorage: UserDefaultsStoring {
    private let defaults = UserDefaults.standard
    
    func save<Value: Codable>(value: Value, for key: any StorageKeyProtocol) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func fetch<Value: Codable>(for key: any StorageKeyProtocol) -> Value? {
        defaults.object(forKey: key.rawValue) as? Value
    }
}
