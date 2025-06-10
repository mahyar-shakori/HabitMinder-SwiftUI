//
//  HabitMinderApp.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

@main
struct HabitMinderApp: App {
    private let coordinator: MainCoordinator
    private let themeManager = ThemeManager()

    init() {
        self.coordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
                .modelContainer(for: [HabitModel.self, FutureHabitModel.self])
                .environmentObject(LanguageManager.shared)
                .environmentObject(themeManager)
        }
    }
}
