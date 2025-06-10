//
//  String+Localization.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

extension String {
    var localized: String {
        let lang = LanguageManager.shared.selectedLanguage.rawValue
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
