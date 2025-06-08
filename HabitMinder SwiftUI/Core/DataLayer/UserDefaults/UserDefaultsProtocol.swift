//
//  UserDefaultsProtocol.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

protocol UserDefaultsStoring {
    associatedtype ValueType
    func save(value: ValueType)
    func fetch() -> ValueType?
}
