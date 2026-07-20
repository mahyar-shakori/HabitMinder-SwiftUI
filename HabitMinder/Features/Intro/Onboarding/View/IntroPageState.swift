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
            IntroImage.HealthyHabit.rawValue

        case .second:
            IntroImage.BadHabit.rawValue
        }
    }

    var title: String {
        switch self {
        case .first:
            L10n.IntroPage.firstTitle

        case .second:
            L10n.IntroPage.secondTitle
        }
    }

    var description: String {
        switch self {
        case .first:
            L10n.IntroPage.firstDescription

        case .second:
            L10n.IntroPage.secondDescription
        }
    }
}
