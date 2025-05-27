//
//  IntroViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class IntroViewModel: ObservableObject {
    @Published private(set) var currentState: IntroViewState = .first
    
    var pageState: IntroUIState {
        currentState.pageState
    }
    
    func nextState() {
        switch currentState {
        case .first:
            currentState = .second
        case .second:
            break
        }
    }
}
