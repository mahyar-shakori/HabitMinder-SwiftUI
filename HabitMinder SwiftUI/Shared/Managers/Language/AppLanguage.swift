//
//  AppLanguage.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case en = "en"
    case nl = "nl"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: 
            return "English"
        case .nl: 
            return "Nederlands"
        }
    }
    
    var displayImage: String {
        switch self {
        case .en: 
            return "EnglishFlag"
        case .nl: 
            return "NederlandsFlag"
        }
    }
}
