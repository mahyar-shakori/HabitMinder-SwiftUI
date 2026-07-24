//
//  SettingsActionRow.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct SettingsActionRow<Accessory: View>: View {
    let iconName: String
    let title: String
    let subtitle: String?
    var foregroundColor: Color = .primary
    var iconForegroundColor: Color?
    var iconBackgroundColor: Color?
    var showsChevron = false
    var isTitleBold = true
    var action: () -> Void
    @ViewBuilder var accessory: () -> Accessory

    init(
        iconName: String,
        title: String,
        subtitle: String? = nil,
        foregroundColor: Color = .primary,
        iconForegroundColor: Color? = nil,
        iconBackgroundColor: Color? = nil,
        showsChevron: Bool = false,
        isTitleBold: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder accessory: @escaping () -> Accessory
    ) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.foregroundColor = foregroundColor
        self.iconForegroundColor = iconForegroundColor
        self.iconBackgroundColor = iconBackgroundColor
        self.showsChevron = showsChevron
        self.isTitleBold = isTitleBold
        self.action = action
        self.accessory = accessory
    }

    var body: some View {
        Button(action: action) {
            rowContent
        }
        .buttonStyle(.plain)
    }

    private var rowContent: some View {
        HStack(spacing: Spacing.large) {
            SettingsRowIcon(
                iconName: iconName,
                foregroundColor: iconForegroundColor,
                backgroundColor: iconBackgroundColor
            )

            VStack(alignment: .leading, spacing: Spacing.x3Small) {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(foregroundColor)

                if let subtitle {
                    Text(subtitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            accessory()

            if showsChevron {
                Image(systemName: SystemIconName.chevronRight)
                    .font(.system(size: FontSize.x4Large, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
        .frame(maxWidth: .infinity, minHeight: Size.x5Large + Spacing.xSmall)
        .liquidGlass(
            in: .rect(cornerRadius: CornerRadius.medium),
            fallback: .appWhite
        )
    }

    private var titleFont: Font {
        if isTitleBold {
            return .AppFont.rooneySansBold.size(FontSize.x4Large)
        }

        return .AppFont.rooneySansRegular.size(FontSize.x4Large)
    }
}

extension SettingsActionRow where Accessory == EmptyView {
    init(
        iconName: String,
        title: String,
        subtitle: String? = nil,
        foregroundColor: Color = .primary,
        iconForegroundColor: Color? = nil,
        iconBackgroundColor: Color? = nil,
        showsChevron: Bool = false,
        isTitleBold: Bool = true,
        action: @escaping () -> Void
    ) {
        self.init(
            iconName: iconName,
            title: title,
            subtitle: subtitle,
            foregroundColor: foregroundColor,
            iconForegroundColor: iconForegroundColor,
            iconBackgroundColor: iconBackgroundColor,
            showsChevron: showsChevron,
            isTitleBold: isTitleBold,
            action: action,
            accessory: EmptyView.init
        )
    }
}
