//
//  ProfileSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct ProfileSettingsView: View {
    private var viewModel: ProfileSettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var editedUserName = ""

    init(viewModel: ProfileSettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
            SettingsActionRow(
                iconName: SystemIconName.pencil,
                title: L10n.SettingPage.editUserName,
                subtitle: viewModel.userName,
                showsChevron: true,
                isTitleBold: false,
                action: startEditingUserName
            )
        }
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
    let dependencies = AppDependencies()
    let settingsDependencies = dependencies.destinationDependencies.main.settings
    let viewModel = ProfileSettingsViewModel(
        userDefaultsStorage: settingsDependencies.userDefaultsStorage,
        profileImageStorage: settingsDependencies.profileImageStorage
    )

    NavigationStack {
        ProfileSettingsView(viewModel: viewModel)
            .environmentObject(dependencies.themeManager)
    }
}
