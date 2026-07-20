//
//  AppRoute.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

enum AppRoute: Hashable {
    case intro(IntroRoute)
    case main(MainRoute)
}

enum IntroRoute: Hashable {
    case onboarding
    case setName
    case welcome
}

enum MainRoute: Hashable {
    case habits(HabitRoute)
    case manageHabit(ManageHabitRoute)
    case settings(SettingsRoute)
}

enum HabitRoute: Hashable {
    case home(quote: String, author: String)
    case history
}

enum ManageHabitRoute: Hashable {
    case add
    case edit(id: UUID)
}

enum SettingsRoute: Hashable {
    case settings
}
