//
//  AppDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI
import SwiftData

struct AppDestinationView: View {
    let route: AppRoute
    let dependencies: AppDestinationDependencies
    let coordinator: MainCoordinator
    let modelContext: ModelContext

    var body: some View {
        switch route {
        case .intro(let introRoute):
            IntroDestinationView(
                route: introRoute,
                dependencies: dependencies.intro,
                coordinator: coordinator
            )
        case .main(let mainRoute):
            MainDestinationView(
                route: mainRoute,
                dependencies: dependencies.main,
                coordinator: coordinator,
                modelContext: modelContext
            )
        }
    }
}
