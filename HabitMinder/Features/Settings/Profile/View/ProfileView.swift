//
//  ProfileSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftData
import SwiftUI

struct ProfileView: View {
    private let profileViewModel: ProfileViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var showLogoutAlert = false
    @State private var editedUserName = ""

    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }

    var body: some View {
        VStack(spacing: Spacing.none) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.x5Large) {
                    profilePhotoSection
                    profileDetailsSection
                }
                .padding(.horizontal, Spacing.x4Large)
                .padding(.top, Spacing.x5Large)
                .padding(.bottom, Spacing.x5Large)
            }
            .scrollIndicators(.hidden)

            logoutSection
        }
        .background(.appGray)
        .navigationTitle(L10n.SettingsPage.profile)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            profileViewModel.loadProfile()
            editedUserName = profileViewModel.userName
        }
        .alert(L10n.ProfilePage.editUserName, isPresented: $isEditingUserName) {
            TextField(L10n.ProfilePage.enterNewUserName, text: $editedUserName)

            Button(L10n.Shared.saveButton) {
                saveEditedUserName()
            }

            Button(L10n.Shared.cancelButton, role: .cancel) {
                editedUserName = profileViewModel.userName
            }
        }
        .alert(L10n.Alert.Logout.title, isPresented: $showLogoutAlert) {
            Button(L10n.Alert.Logout.logoutButton, role: .destructive) {
                profileViewModel.logout()
            }

            Button(L10n.Shared.cancelButton, role: .cancel) {
            }
        } message: {
            Text(logoutAlertMessage)
        }
    }

    private var profilePhotoSection: some View {
        VStack(spacing: Spacing.medium) {
            ProfilePhotoPickerButton(
                imageData: profileViewModel.profileImageData,
                imageSize: Size.emptyImage,
                placeholderPadding: Spacing.x5Large,
                borderColor: themeManager.appPrimary.opacity(Opacity.subtleBorder),
                editIconSize: FontSize.x5Large,
                editBadgeSize: Size.x2Large,
                editBadgeOffset: Spacing.none,
                onImagePicked: profileViewModel.setProfileImage
            )

            Text(L10n.ProfilePage.changePhoto)
                .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.x4Large)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }

    private var profileDetailsSection: some View {
        SettingsSection(title: L10n.SettingsPage.profile, style: .primary) {
            VStack(spacing: Spacing.medium) {
                SettingsActionRow(
                    iconName: SystemIconName.pencil,
                    title: L10n.ProfilePage.editUserName,
                    subtitle: profileViewModel.userName,
                    showsChevron: true,
                    isTitleBold: false,
                    action: startEditingUserName
                )

                emailInfoRow
            }
        }
    }

    private var emailInfoRow: some View {
        HStack(spacing: Spacing.large) {
            SettingsRowIcon(
                iconName: SystemIconName.envelope,
                foregroundColor: .secondary,
                backgroundColor: .gray.opacity(Opacity.subtle),
                isEnabled: false
            )

            VStack(alignment: .leading, spacing: Spacing.x3Small) {
                Text(L10n.ProfilePage.email)
                    .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                    .foregroundStyle(.secondary)

                Text(profileEmailText)
                    .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
        .frame(maxWidth: .infinity, minHeight: Size.x5Large + Spacing.xSmall)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }

    private var logoutSection: some View {
        SettingsActionRow(
            iconName: SystemIconName.arrowRightSquare,
            title: "Log out",
            subtitle: logoutSubtitle,
            foregroundColor: .red,
            iconForegroundColor: .red,
            iconBackgroundColor: themeManager.appSecondary.opacity(Opacity.subtle),
            isTitleBold: false
        ) {
            showLogoutAlert = true
        }
        .padding(.horizontal, Spacing.x4Large)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.x5Large)
        .background(.appGray)
    }

    private var profileEmailText: String {
        profileViewModel.userEmail.isEmpty ? "No email saved" : profileViewModel.userEmail
    }

    private var logoutSubtitle: String {
        profileViewModel.isSignedInWithApple
        ? "Your iCloud data will stay available"
        : "Local account data is not synced to iCloud"
    }

    private var logoutAlertMessage: String {
        profileViewModel.isSignedInWithApple
        ? "Your habits and account settings stay synced with iCloud and will be available when you log in again."
        : "This account is local. If you delete the app or switch devices, this account data may be lost."
    }

    private func startEditingUserName() {
        editedUserName = profileViewModel.userName
        isEditingUserName = true
    }

    private func saveEditedUserName() {
        guard let updatedName = profileViewModel.updateUserName(editedUserName) else {
            editedUserName = profileViewModel.userName
            return
        }

        editedUserName = updatedName
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
    let logoutUseCase = LogoutUseCase(
        dataManager: DataManager(context: context),
        reminderScheduler: settingsDependencies.reminderScheduler,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        themeManager: settingsDependencies.themeManager,
        profileImageStorage: settingsDependencies.profileImageStorage
    )
    let viewModel = ProfileViewModel(
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        profileImageUseCase: settingsDependencies.profileImageUseCase,
        logoutUseCase: logoutUseCase,
        coordinator: fakeCoordinator
    )

    NavigationStack {
        ProfileView(profileViewModel: viewModel)
            .environmentObject(dependencies.themeManager)
    }
}
