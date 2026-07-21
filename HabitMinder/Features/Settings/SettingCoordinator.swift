//
//  SettingCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/05/2025.
//

import Foundation

final class SettingCoordinator: SettingCoordinating {
    private let dismiss: () -> Void
    private let navigateToSettingsRoute: (SettingsRoute) -> Void
    private let resetToSetName: () -> Void
    
    init(
        dismiss: @escaping () -> Void,
        navigateToSettingsRoute: @escaping (SettingsRoute) -> Void,
        resetToSetName: @escaping () -> Void
    ) {
        self.dismiss = dismiss
        self.navigateToSettingsRoute = navigateToSettingsRoute
        self.resetToSetName = resetToSetName
    }
    
    func goBack() {
        dismiss()
    }

    func goToNotificationSettings() {
        navigateToSettingsRoute(.notifications)
    }

    func goToAppTheme() {
        navigateToSettingsRoute(.appTheme)
    }

    func goToSetName() {
        resetToSetName()
    }
}
