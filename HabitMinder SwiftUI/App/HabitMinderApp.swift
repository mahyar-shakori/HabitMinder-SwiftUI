//
//  HabitMinderApp.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

@main
struct HabitMinderApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: HabitModel.self)
        }
    }
}
