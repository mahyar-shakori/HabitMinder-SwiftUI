//
//  UserDefaultsStoring.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

protocol UserDefaultsStoring {
    func save<Value: Codable>(value: Value, for key: any StorageKeyProtocol)
    func fetch<Value: Codable>(for key: any StorageKeyProtocol) -> Value?
}
