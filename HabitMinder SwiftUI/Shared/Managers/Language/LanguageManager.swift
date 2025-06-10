//
//  LanguageManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

final class LanguageManager: ObservableObject {
    @Published var selectedLanguage: AppLanguage {
        didSet {
            languageStorage.save(value: selectedLanguage.rawValue)
        }
    }
    
    static let shared = LanguageManager()
    private let languageStorage: AnyUserDefaultsStorage<String>

    private init(languageStorage: AnyUserDefaultsStorage<String> = DIContainer.UserDefaults.languageStorage) {
        self.languageStorage = languageStorage
        let saved = languageStorage.fetch() ?? "en"
        self.selectedLanguage = AppLanguage(rawValue: saved) ?? .en
    }
}
