//
//  AnyUserDefaultsStorage.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/06/2025.
//

import Foundation

final class AnyUserDefaultsStorage<Value>: UserDefaultsStoring {
    private let _save: (Value) -> Void
    private let _fetch: () -> Value?

    init<U: UserDefaultsStoring>(_ storage: U) where U.ValueType == Value {
        _save = storage.save
        _fetch = storage.fetch
    }

    func save(value: Value) { _save(value) }
    func fetch() -> Value? { _fetch() }
}
