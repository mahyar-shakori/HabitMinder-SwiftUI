//
//  LanguageManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    let languageStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .language)

    @Published var selectedLanguage: AppLanguage {
        didSet {
            languageStorage.save(value: selectedLanguage.displayName)
        }
    }

    private init() {
        self.selectedLanguage = AppLanguage(rawValue: languageStorage.fetch() ?? "en") ?? .en
    }
}
