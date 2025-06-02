//
//  ThemeManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var appPrimary: Color {
        didSet {
            saveColorToDefaults(appPrimary)
        }
    }

    var appSecondary: Color {
        appPrimary.opacity(0.4)
    }

    static let shared = ThemeManager()

    private init() {
        self.appPrimary = Self.loadColorFromDefaults() ?? .appPrimary
    }

    private func saveColorToDefaults(_ color: Color) {
        let colorStorage = UserDefaultsStorage<UserDefaultKeys, [CGFloat]>(key: .appPrimaryColor)

        if let components = color.rgbaComponents {
            colorStorage.save(value: components)

        }
    }

    private static func loadColorFromDefaults() -> Color? {
        let colorStorage = UserDefaultsStorage<UserDefaultKeys, [CGFloat]>(key: .appPrimaryColor)

        guard let components = colorStorage.fetch(), components.count == 4 else {
                return nil
            }
        return Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
}
