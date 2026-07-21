//
//  MainDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI
import SwiftData

struct MainDestinationView: View {
    let route: MainRoute
    let dependencies: MainDestinationDependencies
    let coordinator: MainCoordinator
    let modelContext: ModelContext

    var body: some View {
        switch route {
        case .habits(let habitRoute):
            HabitDestinationView(
                route: habitRoute,
                dependencies: dependencies.habits,
                coordinator: coordinator,
                modelContext: modelContext
            )
        case .manageHabit(let manageHabitRoute):
            ManageHabitDestinationView(
                route: manageHabitRoute,
                dependencies: dependencies.manageHabit,
                coordinator: coordinator,
                modelContext: modelContext
            )
        case .settings(let settingsRoute):
            SettingsDestinationView(
                route: settingsRoute,
                dependencies: dependencies.settings,
                coordinator: coordinator,
                modelContext: modelContext
            )
        }
    }
}
