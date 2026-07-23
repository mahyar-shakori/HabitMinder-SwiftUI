//
//  SettingsDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI
import SwiftData

struct SettingsDestinationView: View {
    let route: SettingsRoute
    let dependencies: SettingsDestinationDependencies
    let coordinator: MainCoordinator
    let modelContext: ModelContext

    var body: some View {
        switch route {
        case .settings:
            let viewCoordinator = SettingsCoordinator(
                dismiss: coordinator.pop,
                navigateToSettingsRoute: { coordinator.navigate(to: .main(.settings($0))) },
                resetToSetName: { coordinator.reset(to: .intro(.setName)) }
            )
            let viewModel = SettingsViewModel(
                coordinator: viewCoordinator,
                userDefaultsStorage: dependencies.userDefaultsStorage,
                profileImageUseCase: dependencies.profileImageUseCase
            )
            SettingsView(settingsViewModel: viewModel)
        case .profile:
            let viewCoordinator = SettingsCoordinator(
                dismiss: coordinator.pop,
                navigateToSettingsRoute: { coordinator.navigate(to: .main(.settings($0))) },
                resetToSetName: { coordinator.reset(to: .intro(.setName)) }
            )
            let logoutUseCase = LogoutUseCase(
                dataManager: DataManager(context: modelContext),
                reminderScheduler: dependencies.reminderScheduler,
                userDefaultsStorage: dependencies.userDefaultsStorage,
                themeManager: dependencies.themeManager,
                profileImageStorage: dependencies.profileImageStorage
            )
            let viewModel = ProfileViewModel(
                userDefaultsStorage: dependencies.userDefaultsStorage,
                profileImageUseCase: dependencies.profileImageUseCase,
                logoutUseCase: logoutUseCase,
                coordinator: viewCoordinator
            )
            ProfileView(profileViewModel: viewModel)
        case .notifications:
            let viewModel = NotificationSettingsViewModel(
                dataManager: DataManager(context: modelContext),
                reminderScheduler: dependencies.reminderScheduler,
                userDefaultsStorage: dependencies.userDefaultsStorage
            )
            NotificationSettingsView(viewModel: viewModel)
        case .appTheme:
            ThemeView()
        }
    }
}
