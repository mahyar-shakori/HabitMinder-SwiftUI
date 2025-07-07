//
//  MainRouting.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import SwiftUI
import SwiftData

protocol MainRouting {
    func view(for route: MainRoute, using coordinator: any MainCoordinating, modelContext: ModelContext) -> any View
}
