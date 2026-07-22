//
//  ProfileSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import PhotosUI
import SwiftUI

struct ProfileSettingsView: View {
    private var viewModel: ProfileSettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var editedUserName = ""
    @State private var isShowingPhotoPicker = false
    @State private var selectedProfilePhoto: PhotosPickerItem?

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
        .onChange(of: selectedProfilePhoto) { _, newItem in
            loadProfilePhoto(from: newItem)
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedProfilePhoto,
            matching: .images
        )
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
            Button {
                isShowingPhotoPicker = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    profileImage

                    Image(systemName: SystemIconName.pencil)
                        .font(.system(size: FontSize.x5Large, weight: .bold))
                        .foregroundStyle(.appWhite)
                        .frame(width: Size.x2Large, height: Size.x2Large)
                        .liquidGlass(
                            tint: themeManager.appPrimary,
                            in: Circle(),
                            fallback: themeManager.appPrimary
                        )
                }
            }
            .buttonStyle(.plain)

            Text(L10n.SettingPage.changePhoto)
                .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.x4Large)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }

    private var profileImage: some View {
        Group {
            if let data = viewModel.profileImageData,
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
                    .padding(Spacing.x5Large)
                    .background(themeManager.appSecondary.opacity(Opacity.subtle))
            }
        }
        .frame(width: Size.emptyImage, height: Size.emptyImage)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(themeManager.appPrimary.opacity(Opacity.subtleBorder), lineWidth: LineWidth.medium)
        }
    }

    private var profileDetailsSection: some View {
        settingsSection(title: L10n.SettingPage.profile) {
            Button {
                startEditingUserName()
            } label: {
                HStack(spacing: Spacing.large) {
                    rowIcon(SystemIconName.pencil)

                    VStack(alignment: .leading, spacing: Spacing.x3Small) {
                        Text(L10n.SettingPage.editUserName)
                            .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                            .foregroundStyle(.primary)

                        Text(viewModel.userName)
                            .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: SystemIconName.chevronRight)
                        .font(.system(size: FontSize.x4Large, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.large)
                .frame(maxWidth: .infinity, minHeight: Size.x5Large + Spacing.xSmall)
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
            }
            .buttonStyle(.plain)
        }
    }

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(title.uppercased())
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .padding(.horizontal, Spacing.large)

            content()
        }
    }

    private func rowIcon(_ iconName: String) -> some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Opacity.badgeBackground))

            Image(systemName: iconName)
                .font(.system(size: FontSize.x5Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x2Large, height: Size.x2Large)
    }

    private func startEditingUserName() {
        editedUserName = viewModel.userName
        isEditingUserName = true
    }

    private func saveEditedUserName() {
        let trimmedName = editedUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isNotEmpty else {
            editedUserName = viewModel.userName
            return
        }

        viewModel.setUserName(trimmedName)
        editedUserName = trimmedName
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
                viewModel.setProfileImage(data: data)
            }
        }
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
