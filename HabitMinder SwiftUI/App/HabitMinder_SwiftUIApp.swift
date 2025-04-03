//
//  HabitMinder_SwiftUIApp.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

@main
struct HabitMinder_SwiftUIApp: App {
    @StateObject private var navigationCoordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigationCoordinator)
        }
    }
}
