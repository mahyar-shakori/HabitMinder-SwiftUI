//
//  Logger+Category.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import OSLog

extension Logger {
    static let watch = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "WatchConnectivity")
    static let data = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "DataManager")
}
