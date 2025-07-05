//
//  MockIntroCoordinator.swift
//  HabitMinder
//
//  Created by Mahyar on 04/07/2025.
//

import Foundation
@testable import HabitMinder

final class MockIntroCoordinator: IntroCoordinating {
    var didNavigate = false
    func goToSetName() {
        didNavigate = true
    }
}
