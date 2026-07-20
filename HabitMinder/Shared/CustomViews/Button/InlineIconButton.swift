//
//  InlineIconButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct InlineIconButton: View {
    enum Variant: Equatable {
        case plain
        case outlinedCircle
    }

    let systemImage: String
    let variant: Variant
    let size: CGFloat
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let action: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        systemImage: String,
        variant: Variant = .plain,
        size: CGFloat = Size.medium,
        fontSize: CGFloat = FontSize.xSmall,
        fontWeight: Font.Weight = .bold,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.variant = variant
        self.size = size
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: fontSize, weight: fontWeight))
                .foregroundStyle(themeManager.appPrimary)
                .frame(width: size, height: size)
                .overlay {
                    if variant == .outlinedCircle {
                        Circle()
                            .stroke(themeManager.appPrimary, lineWidth: LineWidth.thin)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let dependencies = AppDependencies()

    HStack(spacing: Spacing.xLarge) {
        InlineIconButton(systemImage: SystemIconName.xmark) {}
        InlineIconButton(
            systemImage: SystemIconName.plus,
            variant: .outlinedCircle,
            size: Size.large,
            fontSize: FontSize.medium,
            fontWeight: .semibold
        ) {}
    }
    .padding()
    .environmentObject(dependencies.themeManager)
}
