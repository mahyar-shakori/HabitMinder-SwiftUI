//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var mainCoordinator: MainCoordinator
    @Environment(\.modelContext) private var modelContext
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
    
    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            EmptyView()
                .navigationDestination(for: NavigationItem.self) { item in
                    mainCoordinator.coordinator(for: item.route, modelContext: modelContext)
                }
        }
        .onAppear() {
            if mainCoordinator.path.isEmpty {
                mainCoordinator.start()
            }
        }
    }
}

#Preview {
    let userDefaults = UserDefaultsStorage()
    let themeManager = ThemeManager()
    let coordinator = MainCoordinator(
        introRouting: IntroRouter(),
        homeRouting: HomeRouter(),
        userDefaultsStorage: userDefaults
    )
    RootView(mainCoordinator: coordinator)
        .environmentObject(themeManager)
}
