//
//  SetLanguageViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/05/2025.
//

import Foundation

final class SetLanguageViewModel: ObservableObject {
    @Published private var selectedLanguage: AppLanguage
    
    private let languageManager: LanguageManager
    
    init(languageManager: LanguageManager) {
        self.languageManager = languageManager
        self.selectedLanguage = languageManager.selectedLanguage
    }

    func selectLanguage(_ language: AppLanguage) {
        selectedLanguage = language
        languageManager.selectedLanguage = language
    }
}
