//
//  HabitMinderWatchApp.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import SwiftUI

@main
struct HabitMinderWatchApp: App {
    private let homeViewModel: HomeViewModel
    
    init() {
            let sessionManager = WatchSessionManager()
            self.homeViewModel = HomeViewModel(sessionManager: sessionManager)
        }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
