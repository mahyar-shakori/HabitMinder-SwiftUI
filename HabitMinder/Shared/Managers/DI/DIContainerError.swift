//
//  DIContainerError.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

enum DIContainerError: Error, CustomStringConvertible {
    case factoryNotFound(key: String, scope: Scope)
    case instanceTypeMismatch(key: String, scope: Scope)

    var description: String {
        switch self {
        case .factoryNotFound(let key, let scope):
            return "No factory registered for key '\(key)' in scope '\(scope)'"
        case .instanceTypeMismatch(let key, let scope):
            return "Factory returned wrong type for key '\(key)' in scope '\(scope)'"
        }
    }
}
