//
//  SetNameCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class SetNameCoordinator: ObservableObject {
    private let navigate: (AppRoute, PresentationStyle) -> Void
    
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) {
        self.navigate = navigate
    }

    func goToWelcome(presentationStyle: PresentationStyle = .push) {
        navigate(.intro(.welcome), presentationStyle)
    }
}
