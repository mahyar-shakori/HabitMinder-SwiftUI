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
    private let userDefaultsStorage: UserDefaultsStoring
    private let onProfileTap: (() -> Void)?
    @AppStorage(UserDefaultKeys.currentAccountID.rawValue) private var currentAccountID = ""
    @State private var profileImageFileName = ""
    @EnvironmentObject private var themeManager: ThemeManager

    init(
        title: String,
        systemImage: String,
        profileImageStorage: ProfileImageStoring = ProfileImageStorage(),
        userDefaultsStorage: UserDefaultsStoring = UserDefaultsStorage(),
        onProfileTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.profileImageStorage = profileImageStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.onProfileTap = onProfileTap
    }

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            Image(systemName: systemImage)
                .font(.system(size: Spacing.x4Large, weight: .medium))
                .foregroundStyle(.primary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(FontSize.x7Large))
                .foregroundStyle(.primary)

            Spacer()

            profileAction
        }
        .padding(.horizontal, Spacing.x4Large)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.x6Large)
        .onAppear(perform: loadProfileImageFileName)
        .onChange(of: currentAccountID) { _, _ in
            loadProfileImageFileName()
        }
        .onReceive(NotificationCenter.default.publisher(for: AppNotification.Profile.updated)) { _ in
            loadProfileImageFileName()
        }
    }

    private var profileAction: some View {
        Group {
            if let onProfileTap {
                AppProfileButton(action: onProfileTap) {
                    profileIcon
                }
            } else {
                profileIcon
            }
        }
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
                    .foregroundStyle(.appWhite, .secondary)
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

    private func loadProfileImageFileName() {
        let fileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)
        profileImageFileName = fileName ?? ""
    }
}
