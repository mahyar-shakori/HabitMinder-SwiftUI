//
//  SettingsSection.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

enum SettingsSectionStyle {
    case primary
    case grouped

    var spacing: CGFloat {
        switch self {
        case .primary:
            return Spacing.medium
        case .grouped:
            return Spacing.xSmall
        }
    }

    var titleFontSize: CGFloat {
        switch self {
        case .primary:
            return FontSize.small
        case .grouped:
            return FontSize.x3Large
        }
    }

    var titleHorizontalPadding: CGFloat {
        switch self {
        case .primary:
            return Spacing.none
        case .grouped:
            return Spacing.large
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let style: SettingsSectionStyle
    @ViewBuilder let content: () -> Content

    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        style: SettingsSectionStyle = .grouped,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.style = style
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            Text(title.uppercased())
                .font(.AppFont.rooneySansBold.size(style.titleFontSize))
                .foregroundStyle(titleColor)
                .tracking(style == .primary ? 1.2 : 0)
                .padding(.horizontal, style.titleHorizontalPadding)

            content()
        }
    }

    private var titleColor: Color {
        switch style {
        case .primary:
            return themeManager.appPrimary
        case .grouped:
            return .secondary
        }
    }
}
