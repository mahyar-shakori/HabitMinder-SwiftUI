//
//  HabitMinderApp.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

@main
struct HabitMinderApp: App {
    var body: some Scene {
        let userDefaultsStorage = UserDefaultsStorage()
        let mainCoordinator = MainCoordinator(
            introRouting: IntroRouter(),
            homeRouting: HomeRouter(),
            userDefaultsStorage: userDefaultsStorage
        )
        let themeManager = ThemeManager()  

        WindowGroup {
            RootView(mainCoordinator: mainCoordinator)
                .modelContainer(for: [HabitModel.self, FutureHabitModel.self])
                .environmentObject(themeManager)
        }
    }
}
