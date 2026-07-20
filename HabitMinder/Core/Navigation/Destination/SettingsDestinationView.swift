//
//  SettingsDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct SettingsDestinationView: View {
    let route: SettingsRoute
    let dependencies: SettingsDestinationDependencies
    let coordinator: MainCoordinator

    var body: some View {
        switch route {
        case .settings:
            let viewCoordinator = SettingCoordinator(dismiss: coordinator.pop)
            let viewModel = SettingViewModel(
                coordinator: viewCoordinator,
                userDefaultsStorage: dependencies.userDefaultsStorage
            )
            SettingView(settingViewModel: viewModel)
        }
    }
}
