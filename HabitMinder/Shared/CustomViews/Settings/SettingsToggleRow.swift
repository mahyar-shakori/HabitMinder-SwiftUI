//
//  SettingsToggleRow.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct SettingsToggleRow: View {
    let iconName: String
    let title: String
    let isOn: Binding<Bool>
    var isEnabled = true
    var clipsBackground = true

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: Spacing.large) {
            SettingsRowIcon(iconName: iconName, isEnabled: isEnabled)

            Text(title)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                .foregroundStyle(.primary)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(themeManager.appPrimary)
                .disabled(isEnabled.not)
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: clipsBackground ? CornerRadius.medium : 0))
        .opacity(isEnabled ? 1 : Opacity.secondaryTint)
    }
}
