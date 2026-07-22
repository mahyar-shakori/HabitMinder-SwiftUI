//
//  SettingsView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import PhotosUI
import StoreKit
import SwiftUI

struct SettingsView: View {
    private var settingsViewModel: SettingsViewModel
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showLogoutAlert = false
    @State private var isShowingPhotoPicker = false
    @State private var selectedProfilePhoto: PhotosPickerItem?

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
        .onChange(of: selectedProfilePhoto) { _, newItem in
            loadProfilePhoto(from: newItem)
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedProfilePhoto,
            matching: .images
        )
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
            profilePhotoButton

            Text(settingsViewModel.userName)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(settingsViewModel.memberSinceText)
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                .foregroundStyle(.secondary)
        }
        .padding(.top, Spacing.small)
    }

    private var profilePhotoButton: some View {
        Button {
            isShowingPhotoPicker = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                largeProfileImage

                Image(systemName: SystemIconName.pencil)
                    .font(.system(size: FontSize.small, weight: .bold))
                    .foregroundStyle(.appWhite)
                    .frame(width: Size.large, height: Size.large)
                    .liquidGlass(
                        tint: themeManager.appPrimary,
                        in: Circle(),
                        fallback: themeManager.appPrimary
                    )
                    .offset(x: Spacing.x2Small, y: Spacing.x2Small)
            }
        }
        .buttonStyle(.plain)
    }

    private var largeProfileImage: some View {
        Group {
            if let data = settingsViewModel.profileImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: SystemIconName.profile)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.appWhite, themeManager.appPrimary.opacity(Opacity.iconBackground))
                    .padding(Spacing.medium)
                    .background(themeManager.appSecondary.opacity(Opacity.subtle))
            }
        }
        .frame(width: Size.x6Large, height: Size.x6Large)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.appWhite, lineWidth: LineWidth.medium)
        }
    }

    private var settingsContent: some View {
        VStack(alignment: .leading, spacing: Spacing.x5Large) {
            settingsSection(title: L10n.SettingPage.profile) {
                settingsRow(
                    iconName: SystemIconName.profile,
                    title: L10n.SettingPage.profile,
                    subtitle: settingsViewModel.userName,
                    showsChevron: true
                ) {
                    settingsViewModel.showProfileSettings()
                }
            }

            settingsSection(title: L10n.SettingPage.preferences) {
                settingsRow(
                    iconName: SystemIconName.bell,
                    title: L10n.SettingPage.notifications,
                    subtitle: L10n.SettingPage.notificationsSubtitle,
                    showsChevron: true
                ) {
                    settingsViewModel.showNotificationSettings()
                }

                settingsRow(
                    iconName: SystemIconName.paintpalette,
                    title: L10n.SettingPage.appTheme,
                    subtitle: L10n.SettingPage.appThemeSubtitle,
                    showsChevron: true
                ) {
                    settingsViewModel.showAppTheme()
                }
            }

            settingsSection(title: L10n.SettingPage.appSection) {
                settingsRow(
                    iconName: SystemIconName.star,
                    title: L10n.SettingPage.rateUs,
                    subtitle: L10n.SettingPage.rateUsSubtitle
                ) {
                    requestReview()
                }

                settingsRow(
                    iconName: SystemIconName.arrowRightSquare,
                    title: L10n.Cell.DropDown.logout,
                    subtitle: L10n.SettingPage.logoutSubtitle,
                    foregroundColor: .red
                ) {
                    showLogoutAlert = true
                }

                versionFooter
            }
        }
    }


    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(title.uppercased())
                .font(.AppFont.rooneySansBold.size(FontSize.small))
                .foregroundStyle(themeManager.appPrimary)
                .tracking(1.2)

            VStack(spacing: Spacing.medium) {
                content()
            }
        }
    }

    private func settingsRow(
        iconName: String,
        title: String,
        subtitle: String,
        foregroundColor: Color = .primary,
        showsChevron: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            settingsRowContent(
                iconName: iconName,
                title: title,
                subtitle: subtitle,
                foregroundColor: foregroundColor,
                showsChevron: showsChevron
            )
        }
        .buttonStyle(.plain)
    }

    private func settingsRowContent(
        iconName: String,
        title: String,
        subtitle: String,
        foregroundColor: Color = .primary,
        showsChevron: Bool = true
    ) -> some View {
        HStack(spacing: Spacing.large) {
            ZStack {
                Circle()
                    .fill(themeManager.appSecondary.opacity(Opacity.subtle))

                Image(systemName: iconName)
                    .font(.system(size: FontSize.x5Large, weight: .medium))
                    .foregroundStyle(foregroundColor == .red ? .red : themeManager.appPrimary)
            }
            .frame(width: Size.x2Large, height: Size.x2Large)

            VStack(alignment: .leading, spacing: Spacing.x3Small) {
                Text(title)
                    .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                    .foregroundStyle(foregroundColor)

                Text(subtitle)
                    .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if showsChevron {
                Image(systemName: SystemIconName.chevronRight)
                    .font(.system(size: FontSize.x4Large, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
        .frame(maxWidth: .infinity, minHeight: Size.x5Large + Spacing.xSmall)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }

    private func loadProfilePhoto(from item: PhotosPickerItem?) {
        guard let item else {
            return
        }

        Task {
            guard let data = try? await item.loadTransferable(type: Data.self) else {
                return
            }

            await MainActor.run {
                settingsViewModel.setProfileImage(data: data)
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
