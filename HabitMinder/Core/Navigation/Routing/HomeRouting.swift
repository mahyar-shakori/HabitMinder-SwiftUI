//
//  HomeRouting.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import SwiftUI
import SwiftData

protocol HomeRouting {
    func view(for route: HomeRoute, using coordinator: any MainCoordinating, modelContext: ModelContext) -> any View
}
