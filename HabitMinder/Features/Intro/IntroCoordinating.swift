//
//  IntroCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import Foundation

protocol IntroCoordinating {
    func goToSetName(presentationStyle: PresentationStyle)
}

extension IntroCoordinating {
    func goToSetName() {
        goToSetName(presentationStyle: .push)
    }
}
