//
//  HabitMinderApp.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
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
                .modelContainer(for: [HabitModel.self, FutureHabitModel.self])
                .environmentObject(AppDependencies.themeManager)
        }
    }
}
