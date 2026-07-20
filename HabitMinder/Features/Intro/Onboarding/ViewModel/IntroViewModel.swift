//
//  IntroViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation
import Observation

@Observable
final class IntroViewModel {
    private(set) var currentState: IntroPage = .first
    
    private let coordinator: IntroCoordinating

    init(coordinator: IntroCoordinating) {
        self.coordinator = coordinator
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
