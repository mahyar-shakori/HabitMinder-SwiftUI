//
//  HabitMinderApp.swift
//  HabitMinder
//
//  Created by Mahyar on 19/07/2026.
//

import SwiftUI

@main
struct HabitMinderApp: App {
    private let dependencies = AppDependencies()
    private let startupModelContainer = AppStartupModelContainer.resolve()

    var body: some Scene {
        WindowGroup {
            RootView(
                dependencies: dependencies,
                startupModelContainer: startupModelContainer
            )
        }
    }
}
