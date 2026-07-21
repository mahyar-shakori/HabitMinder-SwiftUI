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
        navigate(.main(.manageHabit(.add)))
    }
    
    func goToEditHabit(id: UUID) {
        navigate(.main(.manageHabit(.edit(id: id))))
    }
   
    func goToHabitHistory() {
        navigate(.main(.habits(.history)))
    }
    
    func goToSetting() {
        navigate(.main(.settings(.settings)))
    }
    
    func goToIntro() {
        navigate(.intro(.onboarding))
    }
}
