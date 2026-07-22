//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    private let dependencies: AppDependencies
    @State private var didRequestNotificationAuthorization = false
    @State private var mainCoordinator: MainCoordinator
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _mainCoordinator = State(initialValue: dependencies.mainCoordinator)
    }

    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            Color.clear
                .navigationDestination(for: NavigationItem.self) { item in
                    AppDestinationView(
                        route: item.route,
                        dependencies: dependencies.destinationDependencies,
                        coordinator: mainCoordinator,
                        modelContext: modelContext
                    )
                }
        }
        .preferredColorScheme(themeManager.preferredColorScheme)
        .task {
            mainCoordinator.start()
            requestNotificationAuthorizationIfNeeded()
        }
    }

    private func requestNotificationAuthorizationIfNeeded() {
        guard didRequestNotificationAuthorization.not else {
            return
        }

        didRequestNotificationAuthorization = true
        dependencies.reminderScheduler.requestAuthorization { _ in }
    }
}

#Preview {
    let dependencies = AppDependencies()

    RootView(dependencies: dependencies)
        .environmentObject(dependencies.themeManager)
}
