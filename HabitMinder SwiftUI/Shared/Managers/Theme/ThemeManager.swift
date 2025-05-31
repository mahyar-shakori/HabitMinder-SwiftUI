//
//  ThemeManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var appPrimary: Color = .appPrimary

    static let shared = ThemeManager()

    private init() {}
}
