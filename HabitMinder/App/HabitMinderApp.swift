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

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
                .modelContainer(
                    for: [
                        HabitModel.self,
                        HabitHistoryModel.self
                    ]
                )
                .environmentObject(dependencies.themeManager)
        }
    }
}
