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
            let dataManager = DataManager(context: modelContext)
            let viewCoordinator = SettingCoordinator(
                dismiss: coordinator.pop,
                navigateToSettingsRoute: { coordinator.navigate(to: .main(.settings($0))) },
                resetToSetName: { coordinator.reset(to: .intro(.setName)) }
            )
            let logoutUseCase = LogoutUseCase(
                dataManager: dataManager,
                reminderScheduler: dependencies.reminderScheduler,
                userDefaultsStorage: dependencies.userDefaultsStorage,
                themeManager: dependencies.themeManager,
                profileImageStorage: dependencies.profileImageStorage
            )
            let viewModel = SettingViewModel(
                coordinator: viewCoordinator,
                userDefaultsStorage: dependencies.userDefaultsStorage,
                profileImageStorage: dependencies.profileImageStorage,
                logoutUseCase: logoutUseCase
            )
            SettingView(settingViewModel: viewModel)
        case .notifications:
            let viewModel = NotificationSettingsViewModel(
                dataManager: DataManager(context: modelContext),
                reminderScheduler: dependencies.reminderScheduler,
                userDefaultsStorage: dependencies.userDefaultsStorage
            )
            NotificationSettingsView(viewModel: viewModel)
        case .appTheme:
            ColorPickerView()
        }
    }
}
