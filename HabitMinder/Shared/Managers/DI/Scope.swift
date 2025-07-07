//
//  Scope.swift
//  HabitMinder
//
//  Created by Mahyar on 07/07/2025.
//

import Foundation

enum FeatureScope: String {
    case onboarding, setName, welcome, home, addHabit, editHabit, futureHabit, settingPage, preview, test
}

enum Scope {
    case global
    case feature(FeatureScope)
}
