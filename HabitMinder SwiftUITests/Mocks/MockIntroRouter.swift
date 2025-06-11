//
//  MockIntroRouter.swift
//  HabitMinder
//
//  Created by Mahyar on 11/06/2025.
//

import SwiftUI
@testable import HabitMinder

final class MockIntroRouter: IntroRouting {
    func view(for route: IntroRoute, using coordinator: any BaseCoordinator) -> any View {
        Text("Mock Intro View")
    }
}
