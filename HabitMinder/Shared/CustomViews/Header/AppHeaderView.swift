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
    private let profileImageStorage: ProfileImageStoring
    @AppStorage(UserDefaultKeys.profileImageFileName.rawValue) private var profileImageFileName = ""
    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        systemImage: String,
        profileImageStorage: ProfileImageStoring = ProfileImageStorage()
    ) {
        self.title = title
        self.systemImage = systemImage
        self.profileImageStorage = profileImageStorage
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
        Group {
            if let uiImage = profileImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Size.x3Large, height: Size.x3Large)
            } else {
                Image(systemName: SystemIconName.profile)
                    .font(.system(size: Size.xLarge))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.appWhite, themeManager.appPrimary.opacity(Opacity.iconBackground))
                    .frame(width: Size.xLarge, height: Size.xLarge)
            }
        }
        .clipShape(Circle())
    }

    private var profileImage: UIImage? {
        guard let data = profileImageStorage.loadProfileImage(named: profileImageFileName) else {
            return nil
        }

        return UIImage(data: data)
    }
}
