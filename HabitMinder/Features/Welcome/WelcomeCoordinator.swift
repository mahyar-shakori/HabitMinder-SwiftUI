//
//  WelcomeCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class WelcomeCoordinator: WelcomeCoordinating {
    private let navigate: (AppRoute) -> Void
    
    init(navigate: @escaping (AppRoute) -> Void) {
        self.navigate = navigate
    }
    
    func goToHome(_ quote: String) {
        navigate(.main(.home(quote: quote)))
    }
}
