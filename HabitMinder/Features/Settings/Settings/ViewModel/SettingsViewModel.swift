//
//  SettingViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    private(set) var userName = ""
    private(set) var profileImageData: Data?
    private(set) var memberSinceText = ""

    private let coordinator: SettingsCoordinating
    private let userDefaultsStorage: UserDefaultsStoring
    private let profileImageStorage: ProfileImageStoring
    private let logoutUseCase: LogoutUseCasing

    var appVersion: String {
        AppInfo.version
    }

    init(
        coordinator: SettingsCoordinating,
        userDefaultsStorage: UserDefaultsStoring,
        profileImageStorage: ProfileImageStoring,
        logoutUseCase: LogoutUseCasing
    ) {
        self.coordinator = coordinator
        self.userDefaultsStorage = userDefaultsStorage
        self.profileImageStorage = profileImageStorage
        self.logoutUseCase = logoutUseCase
    }

    func setUserName(_ newName: String) {
        userDefaultsStorage.save(value: newName, for: UserDefaultKeys.userName)
        userName = newName
    }

    func loadUserName() {
        userName = userDefaultsStorage.fetch(for: UserDefaultKeys.userName) ?? L10n.SettingPage.userName
    }

    func loadProfileImage() {
        let fileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)
        profileImageData = fileName.flatMap { profileImageStorage.loadProfileImage(named: $0) }
    }

    func loadMemberSince() {
        let storedDate: Date? = userDefaultsStorage.fetch(for: UserDefaultKeys.userCreatedAt)
        let createdAt = storedDate ?? Date()

        if storedDate == nil {
            userDefaultsStorage.save(value: createdAt, for: UserDefaultKeys.userCreatedAt)
        }

        memberSinceText = L10n.SettingPage.memberSince(formattedMonthYear(from: createdAt))
    }

    func setProfileImage(data: Data) {
        let oldFileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)

        do {
            let fileName = try profileImageStorage.saveProfileImage(data: data, replacing: oldFileName)
            userDefaultsStorage.save(value: fileName, for: UserDefaultKeys.profileImageFileName)
            profileImageData = data
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to save profile image: \(error.localizedDescription)")
#endif
        }
    }

    func showProfileSettings() {
        coordinator.goToProfileSettings()
    }

    func showNotificationSettings() {
        coordinator.goToNotificationSettings()
    }

    func showAppTheme() {
        coordinator.goToAppTheme()
    }

    func logout() {
        logoutUseCase.logout()
        coordinator.goToSetName()
    }

    private func formattedMonthYear(from date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }
}
