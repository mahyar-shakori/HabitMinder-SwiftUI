//
//  UserDefaultsStorage.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class UserDefaultsStorage<Key: StorageKeyProtocol, Value>: UserDefaultsProtocol {
    typealias ValueType = Value
    
    private var key: Key
    
    init(key: Key) {
        self.key = key
    }
    
    func save(value: Value) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func fetch() -> Value? {
        UserDefaults.standard.object(forKey: key.rawValue) as? Value
    }
}
