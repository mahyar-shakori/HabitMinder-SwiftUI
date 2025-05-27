//
//  WelcomeViewCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class WelcomeViewCoordinator: ObservableObject {
    let navigate: (AppRoute, PresentationStyle) -> Void
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) { self.navigate = navigate }

    func goToHome(quote: String, presentationStyle: PresentationStyle = .push) {
        navigate(.home(.home(quote: quote)), presentationStyle)
    }
}
