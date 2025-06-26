//
//  HomeCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class HomeCoordinator: HomeCoordinating {
    private let navigate: (AppRoute) -> Void
    
    init(navigate: @escaping (AppRoute) -> Void) {
        self.navigate = navigate
    }

    func goToAddHabit() {
        navigate(.home(.addHabit))
    }
    
    func goToEditHabit(habit: HabitModel) {
        navigate(.home(.editHabit(habit: habit)))
    }
   
    func goToFutureHabit() {
        navigate(.home(.futureHabit))
    }
    
    func goToSetting() {
        navigate(.home(.settingPage))
    }
    
    func goToIntro() {
        navigate(.intro(.intro))
    }
}
