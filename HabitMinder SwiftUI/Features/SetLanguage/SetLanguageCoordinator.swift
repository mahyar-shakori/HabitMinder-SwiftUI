//
//  SetLanguageCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class SetLanguageCoordinator: ObservableObject {
    private let navigate: (AppRoute, PresentationStyle) -> Void
    
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) {
        self.navigate = navigate
    }

    func goToIntro(presentationStyle: PresentationStyle = .push) {
        navigate(.intro(.intro), presentationStyle)
    }
}
