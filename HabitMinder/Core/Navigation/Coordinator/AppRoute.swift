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
    case home(quote: String)
    case addHabit
    case editHabit(habit: HabitModel)
    case futureHabit
    case settingPage
}
