//
//  SettingsRowIcon.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct SettingsRowIcon: View {
    let iconName: String
    var foregroundColor: Color?
    var backgroundColor: Color?
    var isEnabled = true

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Circle()
                .fill(resolvedBackgroundColor)

            Image(systemName: iconName)
                .font(.system(size: FontSize.x5Large, weight: .medium))
                .foregroundStyle(resolvedForegroundColor)
        }
        .frame(width: Size.x2Large, height: Size.x2Large)
    }

    private var resolvedForegroundColor: Color {
        guard isEnabled else {
            return .secondary
        }

        return foregroundColor ?? .secondary
    }

    private var resolvedBackgroundColor: Color {
        guard isEnabled else {
            return .gray.opacity(Opacity.subtle)
        }

        return backgroundColor ?? .secondary
    }
}
