//
//  HomeCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol HomeCoordinating {
    func goToAddHabit(presentationStyle: PresentationStyle)
    func goToEditHabit(habit: HabitModel, presentationStyle: PresentationStyle)
    func goToFutureHabit(presentationStyle: PresentationStyle)
    func goToSetting(presentationStyle: PresentationStyle)
    func goToSetLanguage(presentationStyle: PresentationStyle)
}

extension HomeCoordinating {
    func goToAddHabit() {
        goToAddHabit(presentationStyle: .push)
    }
    
    func goToEditHabit(habit: HabitModel) {
        goToEditHabit(habit: habit, presentationStyle: .push)
    }

    func goToFutureHabit() {
        goToFutureHabit(presentationStyle: .push)
    }
    
    func goToSetting() {
        goToSetting(presentationStyle: .push)
    }
    
    func goToSetLanguage() {
        goToSetLanguage(presentationStyle: .push)
    }
}
