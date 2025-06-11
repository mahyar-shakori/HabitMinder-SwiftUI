//
//  IntroViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class IntroViewModel: ObservableObject {
    @Published private(set) var currentState: IntroViewState = .first
    
    private let coordinator: IntroCoordinating

    init(coordinator: IntroCoordinating) {
        self.coordinator = coordinator
    }
    
    var pageState: IntroUIState {
        currentState.pageState
    }
   
    func nextState() {
        switch currentState {
        case .first:
            currentState = .second
        case .second:
            goToSetNamePage()
        }
    }
    
    func goToSetNamePage() {
        coordinator.goToSetName()
    }
}
