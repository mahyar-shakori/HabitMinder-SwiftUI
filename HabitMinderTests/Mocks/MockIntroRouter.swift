//
//  MockIntroRouter.swift
//  HabitMinder
//
//  Created by Mahyar on 11/06/2025.
//

import SwiftUI
@testable import HabitMinder

final class MockIntroRouter: IntroRouting {
    func view(for route: IntroRoute, using coordinator: any MainCoordinating) -> any View {
        Text("Mock Intro View")
    }
}
