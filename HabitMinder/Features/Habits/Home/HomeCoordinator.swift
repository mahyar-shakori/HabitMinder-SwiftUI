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
        navigate(.main(.addHabit))
    }
    
    func goToEditHabit(habit: HabitModel) {
        navigate(.main(.editHabit(habit: habit)))
    }
   
    func goToFutureHabit() {
        navigate(.main(.futureHabit))
    }
    
    func goToSetting() {
        navigate(.main(.settingPage))
    }
    
    func goToIntro() {
        navigate(.intro(.onboarding))
    }
}
