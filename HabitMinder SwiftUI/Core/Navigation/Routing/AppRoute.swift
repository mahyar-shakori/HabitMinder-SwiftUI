//
//  AppRoute.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

enum AppRoute: Hashable {
    case intro(IntroRoute)
    case home(HomeRoute)
}

enum IntroRoute: Hashable {
    case setLanguage
    case intro
    case setName
    case welcome
}

enum HomeRoute: Hashable {
    case home(quote: String)
    case addHabit
    case editHabit(habit: HabitModel)
    case futureHabit
    case settingPage
}
