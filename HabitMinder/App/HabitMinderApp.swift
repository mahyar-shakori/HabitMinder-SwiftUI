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
    private let themeManager: ThemeManager

    init(
        introRouting: IntroRouting,
        homeRouting: HomeRouting,
        themeManager: ThemeManager
    ) {
        self.coordinator = MainCoordinator(
            introRouting: introRouting,
            homeRouting: homeRouting
        )
        self.themeManager = themeManager
    }
    
    init() {
        self.init(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            themeManager: ThemeManager()
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
