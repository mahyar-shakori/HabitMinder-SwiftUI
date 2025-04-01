//
//  IntroViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

final class IntroViewModel: ObservableObject {

    enum IntroViewState {
        case first, second
    }
    
    @Published var currentState: IntroViewState = .first
    @Published var currentImage = AppImages.HealthyHabit
    @Published var currentTitleText = LocalizedStrings.IntroPage.firstTitleLabel
    @Published var currentDescriptionText = LocalizedStrings.IntroPage.firstDescriptionLabel
    @Published var pageControlDot = AppImages.pageControlDot1st
    @Published var isSkipHidden = false
    
    func nextState() {
        switch currentState {
        case .first:
            updateViewForSecondState()
        case .second:
            break
        }
    }
    
    private func updateViewForSecondState() {
        currentImage = AppImages.BadHabit
        currentTitleText = LocalizedStrings.IntroPage.secondTitleLabel
        currentDescriptionText = LocalizedStrings.IntroPage.secondDescriptionLabel
        pageControlDot = AppImages.pageControlDot2nd
        isSkipHidden = true
        currentState = .second
    }
}
