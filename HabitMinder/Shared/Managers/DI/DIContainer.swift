//
//  DIContainer.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

final class DIContainer {
    private struct Registration {
        let factory: (DIContainer) -> Any
        var instance: Any?
    }

    private var registrations: [ObjectIdentifier: Registration] = [:]
    private let lock = NSRecursiveLock()

    func register<Service>(
        _ type: Service.Type = Service.self,
        factory: @escaping (DIContainer) -> Service
    ) {
        let key = ObjectIdentifier(type)
        lock.lock()

        defer {
            lock.unlock()
        }

        registrations[key] = Registration(
            factory: { container in
                factory(container)
            },
            instance: nil
        )
    }

    func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        let key = ObjectIdentifier(type)

        lock.lock()

        defer {
            lock.unlock()
        }

        guard var registration = registrations[key] else {
            preconditionFailure("No dependency registered for \(type)")
        }

        if let instance = registration.instance as? Service {
            return instance
        }

        guard let instance = registration.factory(self) as? Service else {
            preconditionFailure("Registered dependency for \(type) has the wrong type")
        }

        registration.instance = instance
        registrations[key] = registration

        return instance
    }
}
