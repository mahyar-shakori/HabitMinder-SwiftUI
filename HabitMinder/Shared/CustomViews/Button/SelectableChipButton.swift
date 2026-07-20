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
                .font(.AppFont.rooneySansBold.size(13))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
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

    HStack(spacing: 0) {
        SelectableChipButton(title: "Upcoming", isSelected: true) {}
        SelectableChipButton(title: "Completed", isSelected: false) {}
    }
    .environmentObject(dependencies.themeManager)
}
