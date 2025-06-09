//
//  LanguageManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class LanguageManager: LanguageManaging {
    @Published var selectedLanguage: AppLanguage {
        didSet {
            languageStorage.save(value: selectedLanguage.displayName)
        }
    }
    
    private let languageStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .language)

    init() {
        let saved = languageStorage.fetch() ?? "en"
        self.selectedLanguage = AppLanguage(rawValue: saved) ?? .en
    }
}
