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
    private let profileImageUseCase: ProfileImageUseCasing

    var appVersion: String {
        AppInfo.version
    }

    init(
        coordinator: SettingsCoordinating,
        userDefaultsStorage: UserDefaultsStoring,
        profileImageUseCase: ProfileImageUseCasing
    ) {
        self.coordinator = coordinator
        self.userDefaultsStorage = userDefaultsStorage
        self.profileImageUseCase = profileImageUseCase
    }

    func setUserName(_ newName: String) {
        userDefaultsStorage.save(value: newName, for: UserDefaultKeys.userName)
        userName = newName
    }

    func loadUserName() {
        userName = userDefaultsStorage.fetch(for: UserDefaultKeys.userName) ?? L10n.SettingsPage.userName
    }

    func loadProfileImage() {
        profileImageData = profileImageUseCase.loadProfileImage()
    }

    func loadMemberSince() {
        let storedDate: Date? = userDefaultsStorage.fetch(for: UserDefaultKeys.userCreatedAt)
        let createdAt = storedDate ?? Date()

        if storedDate == nil {
            userDefaultsStorage.save(value: createdAt, for: UserDefaultKeys.userCreatedAt)
        }

        memberSinceText = L10n.SettingsPage.memberSince(formattedMonthYear(from: createdAt))
    }

    func setProfileImage(data: Data) {
        profileImageData = profileImageUseCase.setProfileImage(data: data) ?? profileImageData
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

    private func formattedMonthYear(from date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }
}
