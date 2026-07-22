//
//  ProfileSettingsViewModel.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileSettingsViewModel {
    private(set) var userName = ""
    private(set) var profileImageData: Data?
    private let userDefaultsStorage: UserDefaultsStoring
    private let profileImageStorage: ProfileImageStoring

    init(
        userDefaultsStorage: UserDefaultsStoring,
        profileImageStorage: ProfileImageStoring
    ) {
        self.userDefaultsStorage = userDefaultsStorage
        self.profileImageStorage = profileImageStorage
    }

    func loadProfile() {
        loadUserName()
        loadProfileImage()
    }

    func updateUserName(_ newName: String) -> String? {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isNotEmpty else {
            return nil
        }

        setUserName(trimmedName)
        return trimmedName
    }

    func setUserName(_ newName: String) {
        userDefaultsStorage.save(value: newName, for: UserDefaultKeys.userName)
        userName = newName
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

    private func loadUserName() {
        userName = userDefaultsStorage.fetch(for: UserDefaultKeys.userName) ?? L10n.SettingPage.userName
    }

    private func loadProfileImage() {
        let fileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)
        profileImageData = fileName.flatMap { profileImageStorage.loadProfileImage(named: $0) }
    }
}
