//
//  IntroViewState.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/04/2025.
//

import Foundation

enum IntroViewState {
    case first
    case second

    var pageState: IntroUIState {
        switch self {
        case .first:
            return IntroUIState(
                image: IntroImage.HealthyHabit.rawValue,
                titleText: LocalizedStrings.IntroPage.firstTitle,
                descriptionText: LocalizedStrings.IntroPage.firstDescription,
                isSkipHidden: false
            )
        case .second:
            return IntroUIState(
                image: IntroImage.BadHabit.rawValue,
                titleText: LocalizedStrings.IntroPage.secondTitle,
                descriptionText: LocalizedStrings.IntroPage.secondDescription,
                isSkipHidden: true
            )
        }
    }
}
