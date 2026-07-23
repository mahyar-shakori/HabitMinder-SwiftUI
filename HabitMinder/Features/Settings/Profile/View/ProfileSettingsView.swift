//
//  ProfileSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftData
import SwiftUI

struct ProfileSettingsView: View {
    private var viewModel: ProfileSettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var showLogoutAlert = false
    @State private var editedUserName = ""

    init(viewModel: ProfileSettingsViewModel) {
        self.viewModel = viewModel
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
        .navigationTitle(L10n.SettingPage.profile)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProfile()
            editedUserName = viewModel.userName
        }
        .alert(L10n.SettingPage.editUserName, isPresented: $isEditingUserName) {
            TextField(L10n.SettingPage.enterNewUserName, text: $editedUserName)

            Button(L10n.Shared.saveButton) {
                saveEditedUserName()
            }

            Button(L10n.Shared.cancelButton, role: .cancel) {
                editedUserName = viewModel.userName
            }
        }
        .alert("Log out?", isPresented: $showLogoutAlert) {
            Button("Log out", role: .destructive) {
                viewModel.logout()
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
                imageData: viewModel.profileImageData,
                imageSize: Size.emptyImage,
                placeholderPadding: Spacing.x5Large,
                borderColor: themeManager.appPrimary.opacity(Opacity.subtleBorder),
                editIconSize: FontSize.x5Large,
                editBadgeSize: Size.x2Large,
                editBadgeOffset: Spacing.none,
                onImagePicked: viewModel.setProfileImage
            )

            Text(L10n.SettingPage.changePhoto)
                .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.x4Large)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }

    private var profileDetailsSection: some View {
        SettingsSection(title: L10n.SettingPage.profile, style: .primary) {
            VStack(spacing: Spacing.medium) {
                SettingsActionRow(
                    iconName: SystemIconName.pencil,
                    title: L10n.SettingPage.editUserName,
                    subtitle: viewModel.userName,
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
                Text("Email")
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
        viewModel.userEmail.isEmpty ? "No email saved" : viewModel.userEmail
    }

    private var logoutSubtitle: String {
        viewModel.isSignedInWithApple
        ? "Your iCloud data will stay available"
        : "Local account data is not synced to iCloud"
    }

    private var logoutAlertMessage: String {
        viewModel.isSignedInWithApple
        ? "Your habits and account settings stay synced with iCloud and will be available when you log in again."
        : "This account is local. If you delete the app or switch devices, this account data may be lost."
    }

    private func startEditingUserName() {
        editedUserName = viewModel.userName
        isEditingUserName = true
    }

    private func saveEditedUserName() {
        guard let updatedName = viewModel.updateUserName(editedUserName) else {
            editedUserName = viewModel.userName
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
    let viewModel = ProfileSettingsViewModel(
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        profileImageUseCase: settingsDependencies.profileImageUseCase,
        logoutUseCase: logoutUseCase,
        coordinator: fakeCoordinator
    )

    NavigationStack {
        ProfileSettingsView(viewModel: viewModel)
            .environmentObject(dependencies.themeManager)
    }
}
