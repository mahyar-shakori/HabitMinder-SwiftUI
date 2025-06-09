//
//  SetLanguageCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol SetLanguageCoordinating {
    func goToIntro(presentationStyle: PresentationStyle)
}

extension SetLanguageCoordinating {
    func goToIntro() {
        goToIntro(presentationStyle: .push)
    }
}
