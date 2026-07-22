//
//  HabitHistorySectionHeader.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct HabitHistorySectionHeader: View {
    let title: String
    var subtitle: String?
    var badgeText: String?

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Group {
            if let badgeText {
                HStack {
                    titleText
                    Spacer()
                    badge(badgeText)
                }
            } else {
                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                    titleText

                    if let subtitle {
                        Text(subtitle)
                            .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, Spacing.x2Small)
            }
        }
    }

    private var titleText: some View {
        Text(title.uppercased())
            .font(.AppFont.rooneySansBold.size(FontSize.small))
            .foregroundStyle(themeManager.appPrimary)
            .tracking(1.2)
    }

    private func badge(_ text: String) -> some View {
        Text(text)
            .font(.AppFont.rooneySansBold.size(FontSize.small))
            .foregroundStyle(themeManager.appPrimary)
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.xSmall - LineWidth.thin)
            .background(themeManager.appSecondary.opacity(Opacity.badgeBackground))
            .clipShape(Capsule())
    }
}
