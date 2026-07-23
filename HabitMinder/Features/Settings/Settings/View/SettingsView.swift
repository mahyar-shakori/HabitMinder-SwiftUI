//
//  SettingsView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    private var settingsViewModel: SettingsViewModel
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var themeManager: ThemeManager

    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }

    var body: some View {
        VStack(spacing: Spacing.none) {
            pageHeader

            ScrollView {
                VStack(spacing: Spacing.x5Large) {
                    profileHero
                    settingsContent
                }
                .padding(.horizontal, Spacing.x4Large)
                .padding(.bottom, Spacing.x5Large)
            }
            .scrollIndicators(.hidden)
        }
        .background(.appGray)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            settingsViewModel.loadUserName()
            settingsViewModel.loadProfileImage()
            settingsViewModel.loadMemberSince()
        }
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: L10n.header.title,
            systemImage: SystemIconName.leaf,
            onProfileTap: { settingsViewModel.showProfileSettings() }
        )
    }

    private var profileHero: some View {
        VStack(spacing: Spacing.small) {
            ProfilePhotoPickerButton(
                imageData: settingsViewModel.profileImageData,
                imageSize: Size.x6Large,
                placeholderPadding: Spacing.medium,
                borderColor: .appWhite,
                onImagePicked: settingsViewModel.setProfileImage
            )

            Text(settingsViewModel.userName)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(settingsViewModel.memberSinceText)
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                .foregroundStyle(.secondary)
        }
        .padding(.top, Spacing.small)
    }

    private var settingsContent: some View {
        VStack(alignment: .leading, spacing: Spacing.x5Large) {
            SettingsSection(title: L10n.SettingsPage.profile, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.profile,
                        title: L10n.SettingsPage.profile,
                        subtitle: settingsViewModel.userName,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showProfileSettings
                    )
                }
            }

            SettingsSection(title: L10n.SettingsPage.preferences, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.bell,
                        title: L10n.SettingsPage.notifications,
                        subtitle: L10n.SettingsPage.notificationsSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showNotificationSettings
                    )

                    SettingsActionRow(
                        iconName: SystemIconName.paintpalette,
                        title: L10n.SettingsPage.appTheme,
                        subtitle: L10n.SettingsPage.appThemeSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showAppTheme
                    )
                }
            }

            SettingsSection(title: L10n.SettingsPage.appSection, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.star,
                        title: L10n.SettingsPage.rateUs,
                        subtitle: L10n.SettingsPage.rateUsSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        isTitleBold: false
                    ) {
                        requestReview()
                    }

                    versionFooter
                }
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: Spacing.x2Small) {
            Text(L10n.SettingsPage.appVersion(settingsViewModel.appVersion))
                .font(.AppFont.rooneySansRegular.size(FontSize.small))
                .foregroundStyle(.secondary)

            Text(L10n.SettingsPage.versionTagline)
                .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
                .foregroundStyle(.secondary.opacity(Opacity.sectionTitle))
        }
        .padding(.top, Spacing.medium)
    }
}

#Preview {
    let dependencies = AppDependencies()
    let settingsDependencies = dependencies.destinationDependencies.main.settings
    let fakeCoordinator = SettingsCoordinator(dismiss: {
    }, navigateToSettingsRoute: { _ in
    }, resetToSetName: {
    })
    let viewModel = SettingsViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        profileImageUseCase: settingsDependencies.profileImageUseCase
    )
    SettingsView(settingsViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
