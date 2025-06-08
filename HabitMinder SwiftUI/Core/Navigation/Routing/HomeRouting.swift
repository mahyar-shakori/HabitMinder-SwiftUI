//
//  HomeRouting.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import SwiftUI
import SwiftData

protocol HomeRouting {
    @ViewBuilder
    func view(for route: HomeRoute, using coordinator: any BaseCoordinator, modelContext: ModelContext) -> any View
}
