//
//  IntroViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class IntroViewModel: ObservableObject {
    @Published var currentState: IntroViewState = .first
    @Published var currentImage = AppImages.HealthyHabit
    @Published var currentTitleText = LocalizedStrings.IntroPage.firstTitle
    @Published var currentDescriptionText = LocalizedStrings.IntroPage.firstDescription
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
        currentTitleText = LocalizedStrings.IntroPage.secondTitle
        currentDescriptionText = LocalizedStrings.IntroPage.secondDescription
        pageControlDot = AppImages.pageControlDot2nd
        isSkipHidden = true
        currentState = .second
    }
}
