//
//  DIContainer.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

@MainActor
final class DIContainer {
    private struct Registration {
        let factory: @MainActor (DIContainer) -> Any
        var instance: Any?
    }

    private var registrations: [ObjectIdentifier: Registration] = [:]

    func register<Service>(
        _ type: Service.Type = Service.self,
        factory: @escaping @MainActor (DIContainer) -> Service
    ) {
        let key = ObjectIdentifier(type)
        registrations[key] = Registration(
            factory: { container in
                factory(container)
            },
            instance: nil
        )
    }

    func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        let key = ObjectIdentifier(type)

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
