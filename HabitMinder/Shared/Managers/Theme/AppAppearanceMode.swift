//
//  AppAppearanceMode.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import SwiftUI

enum AppAppearanceMode: String, CaseIterable {
    case light
    case dark
    case system

    var title: String {
        switch self {
        case .light:
            return L10n.SettingPage.appearanceLight
        case .dark:
            return L10n.SettingPage.appearanceDark
        case .system:
            return L10n.SettingPage.appearanceSystem
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
