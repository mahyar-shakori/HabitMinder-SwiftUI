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
    @State private var showLogoutAlert = false

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
        .alert(L10n.Alert.Logout.title, isPresented: $showLogoutAlert) {
            Button(L10n.Shared.yesButton, role: .destructive) {
                settingsViewModel.logout()
            }
            Button(L10n.Shared.cancelButton, role: .cancel) {
            }
        } message: {
            Text(L10n.Alert.Logout.message)
        }
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: L10n.HabitHistoryPage.headerTitle,
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
            SettingsSection(title: L10n.SettingPage.profile, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.profile,
                        title: L10n.SettingPage.profile,
                        subtitle: settingsViewModel.userName,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showProfileSettings
                    )
                }
            }

            SettingsSection(title: L10n.SettingPage.preferences, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.bell,
                        title: L10n.SettingPage.notifications,
                        subtitle: L10n.SettingPage.notificationsSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showNotificationSettings
                    )

                    SettingsActionRow(
                        iconName: SystemIconName.paintpalette,
                        title: L10n.SettingPage.appTheme,
                        subtitle: L10n.SettingPage.appThemeSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        showsChevron: true,
                        isTitleBold: false,
                        action: settingsViewModel.showAppTheme
                    )
                }
            }

            SettingsSection(title: L10n.SettingPage.appSection, style: .primary) {
                VStack(spacing: Spacing.medium) {
                    SettingsActionRow(
                        iconName: SystemIconName.star,
                        title: L10n.SettingPage.rateUs,
                        subtitle: L10n.SettingPage.rateUsSubtitle,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        isTitleBold: false
                    ) {
                        requestReview()
                    }

                    SettingsActionRow(
                        iconName: SystemIconName.arrowRightSquare,
                        title: L10n.Cell.DropDown.logout,
                        subtitle: L10n.SettingPage.logoutSubtitle,
                        foregroundColor: .red,
                        iconForegroundColor: .red,
                        iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
                        isTitleBold: false
                    ) {
                        showLogoutAlert = true
                    }

                    versionFooter
                }
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: Spacing.x2Small) {
            Text(L10n.SettingPage.appVersion(settingsViewModel.appVersion))
                .font(.AppFont.rooneySansRegular.size(FontSize.small))
                .foregroundStyle(.secondary)

            Text(L10n.SettingPage.versionTagline)
                .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
                .foregroundStyle(.secondary.opacity(Opacity.sectionTitle))
        }
        .padding(.top, Spacing.medium)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let settingsDependencies = dependencies.destinationDependencies.main.settings
    let fakeCoordinator = SettingsCoordinator(dismiss: {
    }, navigateToSettingsRoute: { _ in
    }, resetToSetName: {
    })
    let dataManager = DataManager(context: context)
    let logoutUseCase = LogoutUseCase(
        dataManager: dataManager,
        reminderScheduler: settingsDependencies.reminderScheduler,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        themeManager: settingsDependencies.themeManager,
        profileImageStorage: settingsDependencies.profileImageStorage
    )
    let viewModel = SettingsViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        profileImageStorage: settingsDependencies.profileImageStorage,
        logoutUseCase: logoutUseCase
    )
    SettingsView(settingsViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
