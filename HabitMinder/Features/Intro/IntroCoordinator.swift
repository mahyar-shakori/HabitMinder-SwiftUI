//
//  IntroCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class IntroCoordinator: IntroCoordinating {
    private let navigate: (AppRoute, PresentationStyle) -> Void
    
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) {
        self.navigate = navigate
    }

    func goToSetName(presentationStyle: PresentationStyle = .push) {
        navigate(.intro(.setName), presentationStyle)
    }
}
