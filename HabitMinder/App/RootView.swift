//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftData
import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultKeys.currentAccountID.rawValue) private var currentAccountID = ""

    private let dependencies: AppDependencies
    private let startupModelContainer: AppStartupModelContainer

    init(
        dependencies: AppDependencies,
        startupModelContainer: AppStartupModelContainer
    ) {
        self.dependencies = dependencies
        self.startupModelContainer = startupModelContainer
    }

    var body: some View {
        if let modelContainer = startupModelContainer.container {
            RootNavigationView(dependencies: dependencies)
                .modelContainer(modelContainer)
                .environmentObject(dependencies.themeManager)
                .onChange(of: currentAccountID) { _, _ in
                    dependencies.themeManager.loadStoredTheme()
                }
        } else {
            AppStartupErrorView(message: startupModelContainer.errorMessage)
                .environmentObject(dependencies.themeManager)
        }
    }
}

#Preview {
    let dependencies = AppDependencies()

    RootView(
        dependencies: dependencies,
        startupModelContainer: .resolve()
    )
}
