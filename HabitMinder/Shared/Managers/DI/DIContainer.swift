//
//  DIContainer.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    var globalFactories: [String: () -> Any] = [:]
    var globalInstances: [String: Any] = [:]

    var scopedFactories: [FeatureScope: [String: () -> Any]] = [:]
    var scopedInstances: [FeatureScope: [String: Any]] = [:]

    private init() {}
}
