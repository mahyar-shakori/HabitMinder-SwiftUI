//
//  AppStartupModelContainer.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import SwiftData

struct AppStartupModelContainer {
    let container: ModelContainer?
    let errorMessage: String?

    static func resolve() -> AppStartupModelContainer {
        do {
            return AppStartupModelContainer(
                container: try AppModelContainer.make(),
                errorMessage: nil
            )
        } catch {
#if DEBUG
            AppLogger.cloudKit.error("Failed to create CloudKit model container: \(error.localizedDescription)")
#endif
            return resolveInMemoryContainer()
        }
    }

    private static func resolveInMemoryContainer() -> AppStartupModelContainer {
        do {
            return AppStartupModelContainer(
                container: try AppModelContainer.makeInMemory(),
                errorMessage: nil
            )
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to create in-memory model container: \(error.localizedDescription)")
#endif
            return AppStartupModelContainer(
                container: nil,
                errorMessage: error.localizedDescription
            )
        }
    }
}
