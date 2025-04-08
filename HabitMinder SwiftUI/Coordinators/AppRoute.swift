//
//  AppRoute.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

enum AppRoute: Hashable {
    case intro
    case setName
    case welcome
    case home(quote: String)
    case addHabit
}
