//
//  RootNavigationView.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import SwiftUI

struct RootNavigationView: View {
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
