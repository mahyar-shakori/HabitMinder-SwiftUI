//
//  DIContainer+Helpers.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

extension DIContainer {
    func register<T>(_ type: T.Type, scope: Scope = .global, factory: @escaping () -> T) {
        let key = String(describing: type)
        switch scope {
        case .global:
            globalFactories[key] = factory
        case .feature(let feature):
            scopedFactories[feature, default: [:]][key] = factory
        }
    }

    func register<T>(scope: Scope = .global, factory: @escaping () -> T) {
        register(T.self, scope: scope, factory: factory)
    }

    func resolve<T>(_ type: T.Type = T.self, scope: Scope = .global) throws -> T {
        let key = String(describing: type)

        switch scope {
        case .global:
            if let instance = globalInstances[key] as? T {
                return instance
            }
            guard let factory = globalFactories[key] else {
                throw DIContainerError.factoryNotFound(key: key, scope: scope)
            }
            let instance = factory()
            guard let typed = instance as? T else {
                throw DIContainerError.instanceTypeMismatch(key: key, scope: scope)
            }
            globalInstances[key] = typed
            return typed

        case .feature(let feature):
            if let instance = scopedInstances[feature]?[key] as? T {
                return instance
            }
            guard let factory = scopedFactories[feature]?[key] else {
                throw DIContainerError.factoryNotFound(key: key, scope: scope)
            }
            let instance = factory()
            guard let typed = instance as? T else {
                throw DIContainerError.instanceTypeMismatch(key: key, scope: scope)
            }
            scopedInstances[feature, default: [:]][key] = typed
            return typed
        }
    }

    func resolve<T>(scope: Scope = .global) throws -> T {
        try resolve(T.self, scope: scope)
    }

    func resolveOptional<T>(_ type: T.Type = T.self, scope: Scope = .global, fallback: @autoclosure () -> T) -> T {
        (try? resolve(type, scope: scope)) ?? fallback()
    }

    func resolveOptional<T>(scope: Scope = .global, fallback: @autoclosure () -> T) -> T {
        resolveOptional(T.self, scope: scope, fallback: fallback())
    }

    func clear(scope: FeatureScope) {
        scopedInstances[scope] = nil
    }

    func clearAllScopes() {
        scopedInstances.removeAll()
    }

    func clearAll() {
        globalFactories.removeAll()
        globalInstances.removeAll()
        scopedFactories.removeAll()
        scopedInstances.removeAll()
    }
}
