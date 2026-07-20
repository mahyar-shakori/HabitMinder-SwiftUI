//
//  HabitMinderApp.swift
//  HabitMinder
//
//  Created by Mahyar on 19/07/2026.
//

import SwiftUI

@main
struct HabitMinderApp: App {
    
    init() {
        DISetup.registerAllDependencies()
    }
  
    var body: some Scene {
        WindowGroup {
            RootView(mainCoordinator: AppDependencies.mainCoordinator)
                .modelContainer(
                    for: [
                        HabitModel.self,
                        FutureHabitModel.self
                    ]
                )
                .environmentObject(AppDependencies.themeManager)
        }
    }
}
