//
//  AppInfo.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import Foundation

enum AppInfo {
    private static let versionKey = "CFBundleShortVersionString"
    private static let fallbackValue = "-"

    static var version: String {
        guard let version = Bundle.main.infoDictionary?[versionKey] as? String,
              version.isNotEmpty else {
            return fallbackValue
        }

        return version
    }
}
