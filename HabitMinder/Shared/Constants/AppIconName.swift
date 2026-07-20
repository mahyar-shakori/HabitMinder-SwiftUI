//
//  AppIconName.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation

struct AppIconName {
    static let trash = "trash"
    static let pencil = "pencil"
    static let chevronDown = "chevron.down"
}


enum AppImage: String {
    case HealthyHabit = "HealthyHabit"
    case BadHabit = "BadHabit"
}

import SwiftUI

enum Spacing {
    static let x3Small: CGFloat = 2
    static let x2Small: CGFloat = 4
    static let xSmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
    static let x2Large: CGFloat = 64
    static let x3Large: CGFloat = 128
}

enum CornerRadius {
    static let medium: CGFloat = 12
    static let large: CGFloat = 24
}

enum Opacity {
    static let disabledContent: CGFloat = 0.35
    static let subtleBorder: CGFloat = 0.35
    static let iconBackground: CGFloat = 0.12
}

enum LineWidth {
    static let thin: CGFloat = 1
    static let medium: CGFloat = 2
}

enum Scale {
    static let medium: CGFloat = 1.5
}


enum Size {
    static let small: CGFloat = 10
    static let medium: CGFloat = 20
    static let large: CGFloat = 40
    static let xLarge: CGFloat = 70
}

enum Time {
    static let short: CGFloat = 0.3
    static let medium: CGFloat = 20
    static let long: CGFloat = 1
}

enum LineSpacing {
    static let body: CGFloat = 4
}

enum Colors {
    static let screenBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.systemBackground)

    static let primaryAction = Color.blue
    static let disabledAction = Color.gray.opacity(Opacity.disabledContent)

    static let fieldBackground = Color(.tertiarySystemBackground)
    static let fieldBorder = Color.gray.opacity(Opacity.subtleBorder)
}

enum Fonts {
    static let titleLarge = Font.AppFont.rooneySansBold.size(24)
    static let title = Font.AppFont.rooneySansBold.size(21)
    static let bodyLarge = Font.AppFont.rooneySansRegular.size(18)
    static let body = Font.AppFont.rooneySansRegular.size(16)
}

enum Icon {
    static let placesTab = "location.circle"
    static let customTab = "plus.square"
    static let chevron = "chevron.right"
    static let globe = "globe"
    static let error = "exclamationmark.triangle"
}
