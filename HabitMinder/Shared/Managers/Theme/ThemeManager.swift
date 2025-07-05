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
    
    private let userDefaultsStorage: UserDefaultsStoring
    
    var appSecondary: Color {
        appPrimary.opacity(0.4)
    }
    
    init(userDefaultsStorage: UserDefaultsStoring = UserDefaultsStorage()) {
        self.userDefaultsStorage = userDefaultsStorage
        self.appPrimary = Self.loadColorFromDefaults(storage: userDefaultsStorage) ?? .appPrimary
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
