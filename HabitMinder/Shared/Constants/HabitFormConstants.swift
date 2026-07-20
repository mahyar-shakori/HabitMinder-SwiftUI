//
//  HabitFormConstants.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

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
        static let paddedComponentThreshold = LayoutCount.paddedTimeComponentThreshold
    }

    static var weekdays: [HabitWeekdayItem] {
        [
            HabitWeekdayItem(weekday: 1, title: L10n.Shared.Weekday.sundayShort),
            HabitWeekdayItem(weekday: 2, title: L10n.Shared.Weekday.mondayShort),
            HabitWeekdayItem(weekday: 3, title: L10n.Shared.Weekday.tuesdayShort),
            HabitWeekdayItem(weekday: 4, title: L10n.Shared.Weekday.wednesdayShort),
            HabitWeekdayItem(weekday: 5, title: L10n.Shared.Weekday.thursdayShort),
            HabitWeekdayItem(weekday: 6, title: L10n.Shared.Weekday.fridayShort),
            HabitWeekdayItem(weekday: 7, title: L10n.Shared.Weekday.saturdayShort)
        ]
    }

    enum IconName {
        static let drop = "drop"
        static let mindAndBody = "figure.mind.and.body"
        static let book = "book"
        static let cooldown = "figure.cooldown"
        static let leaf = "leaf"
        static let leafCircle = "leaf.circle"
        static let moon = "moon"
        static let paintpalette = "paintpalette"
    }

    static let iconNames = [
        IconName.drop,
        IconName.mindAndBody,
        IconName.book,
        IconName.cooldown,
        IconName.leaf,
        IconName.leafCircle,
        IconName.moon,
        IconName.paintpalette
    ]
}
