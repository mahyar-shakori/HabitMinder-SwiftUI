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
        HStack(spacing: Metrics.spacing) {
            Image(systemName: systemImage)
                .font(.system(size: Metrics.titleIconSize, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(Metrics.titleFontSize))
                .foregroundStyle(themeManager.appPrimary)

            Spacer()

            profileIcon
        }
        .padding(.horizontal, Metrics.horizontalPadding)
        .padding(.top, Metrics.topPadding)
        .padding(.bottom, Metrics.bottomPadding)
    }

    private var profileIcon: some View {
        Image(systemName: AppIconName.profile)
            .font(.system(size: Metrics.profileIconSize))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.appWhite, themeManager.appPrimary.opacity(0.45))
    }
}
private enum Metrics {
    static let spacing: CGFloat = 8
    static let titleIconSize: CGFloat = 22
    static let titleFontSize: CGFloat = 22
    static let horizontalPadding: CGFloat = 22
    static let topPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 28
    static let profileIconSize: CGFloat = 36
}

