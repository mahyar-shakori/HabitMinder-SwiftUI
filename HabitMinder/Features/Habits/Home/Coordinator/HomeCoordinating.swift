//
//  HomeCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol HomeCoordinating {
    func goToAddHabit()
    func goToEditHabit(id: UUID)
    func goToHabitHistory()
    func goToSetting()
    func goToIntro()
}
