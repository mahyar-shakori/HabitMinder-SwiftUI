//
//  SetNameCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol SetNameCoordinating {
    func goToWelcome(presentationStyle: PresentationStyle)
}

extension SetNameCoordinating {
    func goToWelcome() {
        goToWelcome(presentationStyle: .push)
    }
}
