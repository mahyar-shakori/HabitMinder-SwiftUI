//
//  ProfileImageUseCase.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import Foundation

struct ProfileImageUseCase: ProfileImageUseCasing {
    private let userDefaultsStorage: UserDefaultsStoring
    private let profileImageStorage: ProfileImageStoring

    init(
        userDefaultsStorage: UserDefaultsStoring,
        profileImageStorage: ProfileImageStoring
    ) {
        self.userDefaultsStorage = userDefaultsStorage
        self.profileImageStorage = profileImageStorage
    }

    func loadProfileImage() -> Data? {
        let fileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)
        return fileName.flatMap { profileImageStorage.loadProfileImage(named: $0) }
    }

    func setProfileImage(data: Data) -> Data? {
        let oldFileName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.profileImageFileName)

        do {
            let fileName = try profileImageStorage.saveProfileImage(data: data, replacing: oldFileName)
            userDefaultsStorage.save(value: fileName, for: UserDefaultKeys.profileImageFileName)
            NotificationCenter.default.post(name: AppNotification.Profile.updated, object: nil)
            return data
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to save profile image: \(error.localizedDescription)")
#endif
            return nil
        }
    }
}
