//
//  ThemeManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

final class ThemeManager: ThemeManaging {
    @Published var appPrimary: Color {
        didSet {
            saveColorToDefaults(appPrimary)
        }
    }
    
    private let colorStorage: AnyUserDefaultsStorage<[CGFloat]>

    var appSecondary: Color {
        appPrimary.opacity(0.4)
    }

    init(colorStorage: AnyUserDefaultsStorage<[CGFloat]> = DIContainer.UserDefaults().colorStorage) {
        self.colorStorage = colorStorage
        self.appPrimary = Self.loadColorFromDefaults() ?? .appPrimary
    }

    private func saveColorToDefaults(_ color: Color) {
        if let components = color.rgbaComponents {
            colorStorage.save(value: components)
        }
    }

    private static func loadColorFromDefaults() -> Color? {
        let colorStorage = UserDefaultsStorage<UserDefaultKeys, [CGFloat]>(key: .appPrimaryColor)
        guard let components = colorStorage.fetch(), components.count == 4 else {
            return nil
        }
        return Color(.sRGB,
                     red: components[0],
                     green: components[1],
                     blue: components[2],
                     opacity: components[3])
    }
}
