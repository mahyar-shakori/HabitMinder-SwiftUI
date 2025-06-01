//
//  ThemeManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var appPrimary: Color = .appPrimary
    
    var appSecondary: Color {
        appPrimary.opacity(0.4)
    }

    static let shared = ThemeManager()

    private init() {}
}
