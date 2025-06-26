//
//  SetNameCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class SetNameCoordinator: SetNameCoordinating {
    private let navigate: (AppRoute) -> Void
    
    init(navigate: @escaping (AppRoute) -> Void) {
        self.navigate = navigate
    }

    func goToWelcome() {
        navigate(.intro(.welcome))
    }
}
