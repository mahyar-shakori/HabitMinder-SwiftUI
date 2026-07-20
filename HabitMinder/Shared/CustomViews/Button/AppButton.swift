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
            .AppFont.rooneySansBold.size(20)
        case .compactPrimary:
            .AppFont.rooneySansBold.size(13)
        case .secondary, .plain:
            .AppFont.rooneySansBold.size(18)
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .compactPrimary:
            .appWhite
        case .secondary:
            themeManager.appPrimary
        case .plain:
            .blue
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary, .compactPrimary:
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
            16
        case .compactPrimary:
            14
        case .secondary:
            16
        case .plain:
            0
        }
    }

    private var verticalPadding: CGFloat {
        switch variant {
        case .primary:
            16
        case .compactPrimary:
            9
        case .secondary:
            8
        case .plain:
            0
        }
    }
}

private enum PreviewText {
    static let primary = "Primary"
    static let compact = "Compact"
    static let secondary = "Secondary"
    static let plain = "Plain"
}

#Preview {
    let dependencies = AppDependencies()

    VStack(spacing: 16) {
        AppButton(PreviewText.primary, systemImage: AppIconName.sparkles) {}
        AppButton(PreviewText.compact, variant: .compactPrimary) {}
        AppButton(PreviewText.secondary, variant: .secondary) {}
        AppButton(PreviewText.plain, variant: .plain) {}
    }
    .padding()
    .environmentObject(dependencies.themeManager)
}
