//
//  HomeViewCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class HomeViewCoordinator: ObservableObject {
    let navigate: (AppRoute, PresentationStyle) -> Void
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) { self.navigate = navigate }

    func goToAddHabit(presentationStyle: PresentationStyle = .push) {
        navigate(.home(.addHabit), presentationStyle)
    }
    
    func goToFutureHabit(presentationStyle: PresentationStyle = .push) {
        navigate(.home(.futureHabit), presentationStyle)
    }
    
    func goToSetName(presentationStyle: PresentationStyle = .push) {
        navigate(.intro(.setName), presentationStyle)
    }
}
