//
//  HomeCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol HomeCoordinating {
    func goToAddHabit()
    func goToEditHabit(habit: HabitModel)
    func goToFutureHabit()
    func goToSetting()
    func goToIntro()
}

extension HomeCoordinating {
    func goToAddHabit() {
        goToAddHabit()
    }
    
    func goToEditHabit(habit: HabitModel) {
        goToEditHabit(habit: habit)
    }

    func goToFutureHabit() {
        goToFutureHabit()
    }
    
    func goToSetting() {
        goToSetting()
    }
    
    func goToIntro() {
        goToIntro()
    }
}
