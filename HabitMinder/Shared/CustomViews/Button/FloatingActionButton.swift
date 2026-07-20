//
//  FloatingActionButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct FloatingActionButton: View {
    let systemImage: String
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        systemImage: String = "plus",
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 26, weight: .medium))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.appWhite)
        .frame(width: 60, height: 60)
        .circleBackground(themeManager.appPrimary)
    }
}
