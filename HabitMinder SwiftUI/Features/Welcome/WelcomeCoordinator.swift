//
//  WelcomeCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class WelcomeCoordinator: ObservableObject {
    private let navigate: (AppRoute, PresentationStyle) -> Void
    
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) {
        self.navigate = navigate
    }
    
    func goToHome(
        _ quote: String,
        presentationStyle: PresentationStyle = .push
    ) {
        navigate(.home(.home(quote: quote)), presentationStyle)
    }
}
