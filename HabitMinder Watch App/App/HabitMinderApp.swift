//
//  HabitMinderApp.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import SwiftUI

@main
struct HabitMinder_Watch_AppApp: App {
    private let homeViewModel: HomeViewModel
    
    init() {
            // DI: Inject WatchSessionManager into HomeViewModel
            let sessionManager = WatchSessionManager()
            self.homeViewModel = HomeViewModel(sessionManager: sessionManager)
        }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
