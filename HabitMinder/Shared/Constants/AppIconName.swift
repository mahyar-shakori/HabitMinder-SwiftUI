//
//  AppIconName.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct AppIconName {
    static let trash = "trash"
    static let pencil = "pencil"
    static let chevronDown = "chevron.down"
    static let calendar = "calendar"
    static let wandAndStars = "wand.and.stars"
    static let gearshape = "gearshape"
    static let leaf = "leaf"
    static let quoteBubble = "quote.bubble"
    static let flameFill = "flame.fill"
    static let link = "link"
    static let bell = "bell"
    static let minus = "minus"
    static let plus = "plus"
    static let xmark = "xmark"
    static let sparkles = "sparkles"
    static let medal = "medal"
    static let lightbulb = "lightbulb"
    static let profile = "person.crop.circle.fill"
    static let drop = "drop"
    static let mindAndBody = "figure.mind.and.body"
    static let book = "book"
    static let cooldown = "figure.cooldown"
    static let leafCircle = "leaf.circle"
    static let moon = "moon"
    static let paintpalette = "paintpalette"
}


enum AppImage: String {
    case HealthyHabit = "HealthyHabit"
    case BadHabit = "BadHabit"
}

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
struct HabitWeekdayItem {
    let weekday: Int
    let title: String
}

enum HabitFormConstants {
    enum DateFormat {
        static let storageTime = "HH:mm"
        static let displayTime = "hh:mm a"
        static let zeroPrefix = "0"
        static let separator = ":"
        static let paddedComponentThreshold = 10
    }

    enum Metrics {
        static let rootSpacing: CGFloat = 0
        static let contentSpacing: CGFloat = 24
        static let contentHorizontalPadding: CGFloat = 20
        static let contentTopPadding: CGFloat = 20
        static let contentBottomPadding: CGFloat = 24
        static let sectionSpacing: CGFloat = 14
        static let formCardSpacing: CGFloat = 20
        static let reminderSectionSpacing: CGFloat = 12
        static let chipSpacing: CGFloat = 10
        static let iconGridSpacing: CGFloat = 18
        static let weekdayGridSpacing: CGFloat = 8
        static let gridColumnCount = 4
        static let textFieldHorizontalPadding: CGFloat = 16
        static let textFieldHeight: CGFloat = 56
        static let fieldBorderOpacity: CGFloat = 0.22
        static let sectionTitleFontSize: CGFloat = 12
        static let sectionTitleTracking: CGFloat = 2
        static let sectionTitleOpacity: CGFloat = 0.72
        static let formHeaderOpacity: CGFloat = 0.75
        static let hintFontSize: CGFloat = 13
        static let labelFontSize: CGFloat = 12
        static let bodyFontSize: CGFloat = 14
        static let valueFontSize: CGFloat = 16
        static let titleFontSize: CGFloat = 24
        static let topTitleFontSize: CGFloat = 28
        static let reminderRowHorizontalPadding: CGFloat = 14
        static let reminderRowVerticalPadding: CGFloat = 10
        static let reminderRowOpacity: CGFloat = 0.08
        static let reminderRowCornerRadius: CGFloat = 8
        static let reminderListTopPadding: CGFloat = 4
        static let formCardPadding: CGFloat = 20
        static let formCardCornerRadius: CGFloat = 12
        static let stepperSize: CGFloat = 30
        static let stepperFontSize: CGFloat = 13
        static let startButtonShadowOpacity: CGFloat = 0.22
        static let startButtonShadowRadius: CGFloat = 10
        static let startButtonShadowY: CGFloat = 4
        static let startButtonHorizontalPadding: CGFloat = 20
        static let startButtonTopPadding: CGFloat = 12
        static let startButtonBottomPadding: CGFloat = 24
        static let topBarSpacing: CGFloat = 12
        static let topBarHorizontalPadding: CGFloat = 20
        static let topBarTopPadding: CGFloat = 32
        static let toastFontSize: CGFloat = 16
        static let toastVerticalPadding: CGFloat = 8
        static let toastHorizontalPadding: CGFloat = 16
        static let toastOpacity: CGFloat = 0.8
        static let toastCornerRadius: CGFloat = 12
        static let toastBottomPadding: CGFloat = 8
        static let bottomButtonSpacing: CGFloat = 10
        static let bottomButtonsBottomPadding: CGFloat = 18
        static let missButtonHorizontalPadding: CGFloat = 32
        static let missButtonBottomPadding: CGFloat = 32
    }

    static var weekdays: [HabitWeekdayItem] {
        [
            HabitWeekdayItem(weekday: 1, title: LocalizedStrings.Shared.Weekday.sundayShort),
            HabitWeekdayItem(weekday: 2, title: LocalizedStrings.Shared.Weekday.mondayShort),
            HabitWeekdayItem(weekday: 3, title: LocalizedStrings.Shared.Weekday.tuesdayShort),
            HabitWeekdayItem(weekday: 4, title: LocalizedStrings.Shared.Weekday.wednesdayShort),
            HabitWeekdayItem(weekday: 5, title: LocalizedStrings.Shared.Weekday.thursdayShort),
            HabitWeekdayItem(weekday: 6, title: LocalizedStrings.Shared.Weekday.fridayShort),
            HabitWeekdayItem(weekday: 7, title: LocalizedStrings.Shared.Weekday.saturdayShort)
        ]
    }

    static let iconNames = [
        AppIconName.drop,
        AppIconName.mindAndBody,
        AppIconName.book,
        AppIconName.cooldown,
        AppIconName.leaf,
        AppIconName.leafCircle,
        AppIconName.moon,
        AppIconName.paintpalette
    ]
}

