//
//  UserDefaultsStoring.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

protocol UserDefaultsStoring {
    func save<Value>(
        value: Value,
        for key: any StorageKeyProtocol
    )

    func fetch<Value>(for key: any StorageKeyProtocol) -> Value?

    func removeValue(for key: any StorageKeyProtocol)

    func removeAllAppValues()
}
