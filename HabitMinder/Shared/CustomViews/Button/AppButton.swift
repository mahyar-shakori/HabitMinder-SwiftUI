//
//  AppButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct AppButton: View {
    enum Variant: Equatable {
        case primary
        case compactPrimary
        case onboardingNext
        case secondary
        case plain
    }

    let title: String
    let systemImage: String?
    let variant: Variant
    let isEnabled: Bool
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        _ title: String,
        systemImage: String? = nil,
        variant: Variant = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            label
                .font(font)
                .frame(maxWidth: expandsHorizontally ? .infinity : nil)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(isEnabled.not)
    }

    @ViewBuilder
    private var label: some View {
        if let systemImage {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }

    private var font: Font {
        switch variant {
        case .primary:
            .AppFont.rooneySansBold.size(FontSize.x5Large)
        case .compactPrimary:
            .AppFont.rooneySansBold.size(FontSize.medium)
        case .onboardingNext, .secondary, .plain:
            .AppFont.rooneySansBold.size(FontSize.x4Large)
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .compactPrimary, .onboardingNext:
            .appWhite
        case .secondary:
            themeManager.appPrimary
        case .plain:
            .blue
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary, .compactPrimary, .onboardingNext:
            isEnabled ? themeManager.appPrimary : themeManager.appSecondary
        case .secondary, .plain:
            .clear
        }
    }

    private var expandsHorizontally: Bool {
        variant == .primary || variant == .compactPrimary
    }

    private var horizontalPadding: CGFloat {
        switch variant {
        case .primary:
            Spacing.xLarge
        case .compactPrimary:
            Spacing.large
        case .onboardingNext, .secondary:
            Spacing.xLarge
        case .plain:
            Spacing.none
        }
    }

    private var verticalPadding: CGFloat {
        switch variant {
        case .primary:
            Spacing.xLarge
        case .compactPrimary:
            Spacing.xSmall + LineWidth.thin
        case .onboardingNext, .secondary:
            Spacing.xSmall
        case .plain:
            Spacing.none
        }
    }
}


#Preview {
    let dependencies = AppDependencies()

    VStack(spacing: Spacing.medium) {
        AppButton("test", systemImage: SystemIconName.sparkles) {}
        AppButton("test", variant: .compactPrimary) {}
        AppButton("test", variant: .secondary) {}
        AppButton("test", variant: .plain) {}
    }
    .padding()
    .environmentObject(dependencies.themeManager)
}
