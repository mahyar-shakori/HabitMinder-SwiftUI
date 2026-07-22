//
//  AppPrimaryButton.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct AppPrimaryButton: View {
    private let title: String
    private let systemImage: String?
    private let isEnabled: Bool
    private let disablesWhenInvalid: Bool
    private let fillsWidth: Bool
    private let size: AppPrimaryButtonSize
    private let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        systemImage: String? = nil,
        isEnabled: Bool = true,
        disablesWhenInvalid: Bool = true,
        fillsWidth: Bool = true,
        size: AppPrimaryButtonSize = .large,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isEnabled = isEnabled
        self.disablesWhenInvalid = disablesWhenInvalid
        self.fillsWidth = fillsWidth
        self.size = size
        self.action = action
    }

    var body: some View {
        primaryButton
            .disabled(disablesWhenInvalid && isEnabled.not)
    }

    private var primaryButton: some View {
        buttonContent
            .primaryButtonChrome(
                tint: isEnabled ? themeManager.appPrimary : themeManager.appSecondary,
                controlSize: size.controlSize
            )
    }

    private var buttonContent: some View {
        Button(action: action) {
            label
                .font(.AppFont.rooneySansBold.size(size.fontSize))
                .frame(maxWidth: fillsWidth ? .infinity : nil)
        }
    }

    @ViewBuilder
    private var label: some View {
        if let systemImage {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }
}
