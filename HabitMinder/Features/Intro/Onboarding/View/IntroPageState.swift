//
//  IntroPageState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/04/2025.
//

import Foundation

enum IntroPage {
    case first
    case second

    var image: String {
        switch self {
        case .first:
            AppImage.HealthyHabit.rawValue

        case .second:
            AppImage.BadHabit.rawValue
        }
    }

    var title: String {
        switch self {
        case .first:
            LocalizedStrings.IntroPage.firstTitle

        case .second:
            LocalizedStrings.IntroPage.secondTitle
        }
    }

    var description: String {
        switch self {
        case .first:
            LocalizedStrings.IntroPage.firstDescription

        case .second:
            LocalizedStrings.IntroPage.secondDescription
        }
    }
}
