//
//  SelectableChipButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct SelectableChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.AppFont.rooneySansBold.size(FontSize.medium))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xSmall + LineWidth.thin)
                .background(isSelected ? themeManager.appPrimary : .clear)
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
    }
}

#Preview {
    let dependencies = AppDependencies()

    HStack(spacing: Spacing.none) {
        SelectableChipButton(title: L10n.FutureHabitsPage.upcomingTab, isSelected: true) {}
        SelectableChipButton(title: L10n.FutureHabitsPage.completedTab, isSelected: false) {}
    }
    .environmentObject(dependencies.themeManager)
}
