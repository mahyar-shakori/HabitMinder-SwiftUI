//
//  AppHeaderView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct AppHeaderView: View {
    private let title: String
    private let systemImage: String
    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        systemImage: String
    ) {
        self.title = title
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            Image(systemName: systemImage)
                .font(.system(size: Spacing.x4Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(FontSize.x7Large))
                .foregroundStyle(themeManager.appPrimary)

            Spacer()

            profileIcon
        }
        .padding(.horizontal, Spacing.x4Large)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.x6Large)
    }

    private var profileIcon: some View {
        Image(systemName: SystemIconName.profile)
            .font(.system(size: Size.xLarge))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.appWhite, themeManager.appPrimary.opacity(Opacity.iconBackground))
    }
}
