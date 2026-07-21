//
//  HabitFrequency.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 06/06/2025.
//

import Foundation

enum HabitFrequency: String, CaseIterable {
    case daily
    case weekly
    case custom

    var title: String {
        switch self {
        case .daily:
            return L10n.AddHabitPage.frequencyDaily
        case .weekly:
            return L10n.AddHabitPage.frequencyWeekly
        case .custom:
            return L10n.AddHabitPage.frequencyCustom
        }
    }
}
