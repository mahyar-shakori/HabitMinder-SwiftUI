//
//  HomeCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class HomeCoordinator: ObservableObject {
    private let navigate: (AppRoute, PresentationStyle) -> Void
    
    init(navigate: @escaping (AppRoute, PresentationStyle) -> Void) {
        self.navigate = navigate
    }

    func goToAddHabit(presentationStyle: PresentationStyle = .push) {
        navigate(.home(.addHabit), presentationStyle)
    }
    
    func goToEditHabit(
        habit: HabitModel,
        presentationStyle: PresentationStyle = .push
    ) {
        navigate(.home(.editHabit(habit: habit)), presentationStyle)
    }
   
    func goToFutureHabit(presentationStyle: PresentationStyle = .push) {
        navigate(.home(.futureHabit), presentationStyle)
    }
    
    func goToSetting(presentationStyle: PresentationStyle = .push) {
        navigate(.home(.settingPage), presentationStyle)
    }
    
    func goToSetLanguage(presentationStyle: PresentationStyle = .push) {
        navigate(.intro(.setLanguage), presentationStyle)
    }
}
