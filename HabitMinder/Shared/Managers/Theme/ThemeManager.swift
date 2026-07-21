//
//  ThemeManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

final class ThemeManager: ThemeManaging, ObservableObject{
    @Published var appPrimary: Color {
        didSet {
            saveColorToDefaults(appPrimary)
        }
    }

    @Published var appearanceMode: AppAppearanceMode {
        didSet {
            userDefaultsStorage.save(value: appearanceMode.rawValue, for: UserDefaultKeys.appAppearanceMode)
        }
    }
    
    private let userDefaultsStorage: UserDefaultsStoring
    
    var appSecondary: Color {
        appPrimary.opacity(Opacity.secondaryTint)
    }

    var preferredColorScheme: ColorScheme? {
        appearanceMode.colorScheme
    }
    
    init(userDefaultsStorage: UserDefaultsStoring) {
        self.userDefaultsStorage = userDefaultsStorage
        self.appPrimary = Self.loadColorFromDefaults(storage: userDefaultsStorage) ?? .appPrimary
        self.appearanceMode = Self.loadAppearanceMode(from: userDefaultsStorage)
    }

    func resetAppColorToDefault() {
        appPrimary = .appPrimary
        userDefaultsStorage.removeValue(for: UserDefaultKeys.appPrimaryColor)
    }

    func resetToDefault() {
        resetAppColorToDefault()
        appearanceMode = .system
        userDefaultsStorage.removeValue(for: UserDefaultKeys.appAppearanceMode)
    }
    
    private static func loadAppearanceMode(from storage: UserDefaultsStoring) -> AppAppearanceMode {
        let rawValue: String? = storage.fetch(for: UserDefaultKeys.appAppearanceMode)
        return rawValue.flatMap(AppAppearanceMode.init(rawValue:)) ?? .system
    }
    
    private func saveColorToDefaults(_ color: Color) {
        if let components = color.rgbaComponents {
            userDefaultsStorage.save(value: components, for: UserDefaultKeys.appPrimaryColor)
        }
    }
    
    private static func loadColorFromDefaults(storage: UserDefaultsStoring) -> Color? {
        guard let components: [CGFloat] = storage.fetch(for: UserDefaultKeys.appPrimaryColor),
              components.count == 4 else {
            return nil
        }
        return Color(.sRGB,
                     red: components[0],
                     green: components[1],
                     blue: components[2],
                     opacity: components[3])
    }
}
