//
//  AppLogger.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import OSLog

#if DEBUG
struct AppLogger {
    static let watch = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "WatchConnectivity")
    static let data = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "DataManager")
    static let auth = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Auth")
    static let cloudKit = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "CloudKit")
}
#endif
