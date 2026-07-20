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
        systemImage: String = SystemIconName.plus,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: Size.buttonIcon, weight: .medium))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.appWhite)
        .frame(width: Size.x4Large, height: Size.x4Large)
        .circleBackground(themeManager.appPrimary)
    }
}
