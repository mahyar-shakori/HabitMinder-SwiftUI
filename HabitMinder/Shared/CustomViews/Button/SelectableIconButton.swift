//
//  SelectableIconButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct SelectableIconButton: View {
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isSelected ? themeManager.appPrimary : themeManager.appPrimary.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
