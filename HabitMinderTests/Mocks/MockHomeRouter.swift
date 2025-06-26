//
//  MockHomeRouter.swift
//  HabitMinder
//
//  Created by Mahyar on 11/06/2025.
//

import SwiftUI
import SwiftData
@testable import HabitMinder

final class MockHomeRouter: HomeRouting {
    func view(for route: HomeRoute, using coordinator: any MainCoordinating, modelContext: ModelContext) -> any View {
        Text("Mock Home View")
    }
}
