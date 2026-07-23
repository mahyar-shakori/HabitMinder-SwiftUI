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
final class ProfileViewModel {
    private(set) var userName = ""
    private(set) var userEmail = ""
    private(set) var profileImageData: Data?
    private let userDefaultsStorage: UserDefaultsStoring
    private let profileImageUseCase: ProfileImageUseCasing
    private let logoutUseCase: LogoutUseCasing
    private let coordinator: SettingsCoordinating

    var isSignedInWithApple: Bool {
        currentAccountID.hasPrefix("apple:")
    }

    private var currentAccountID: String {
        userDefaultsStorage.fetch(for: UserDefaultKeys.currentAccountID) ?? ""
    }

    init(
        userDefaultsStorage: UserDefaultsStoring,
        profileImageUseCase: ProfileImageUseCasing,
        logoutUseCase: LogoutUseCasing,
        coordinator: SettingsCoordinating
    ) {
        self.userDefaultsStorage = userDefaultsStorage
        self.profileImageUseCase = profileImageUseCase
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator
    }

    func loadProfile() {
        loadUserName()
        loadUserEmail()
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

    func logout() {
        logoutUseCase.logout()
        coordinator.goToSetName()
    }

    func setProfileImage(data: Data) {
        profileImageData = profileImageUseCase.setProfileImage(data: data) ?? profileImageData
    }

    private func loadUserName() {
        userName = userDefaultsStorage.fetch(for: UserDefaultKeys.userName) ?? L10n.ProfilePage.userName
    }

    private func loadUserEmail() {
        userEmail = userDefaultsStorage.fetch(for: UserDefaultKeys.userEmail) ?? ""
    }

    private func loadProfileImage() {
        profileImageData = profileImageUseCase.loadProfileImage()
    }
}
