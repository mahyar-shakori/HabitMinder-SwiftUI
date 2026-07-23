//
//  SignInViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import AuthenticationServices
import Foundation
import Observation

@MainActor
@Observable
final class SignInViewModel {
    private(set) var userName = ""
    private(set) var borderState: BorderState = .normal
    private(set) var errorText = ""
    private(set) var isValid = false
    private let coordinator: SetNameCoordinating
    private let userDefaultsStorage: UserDefaultsStoring

    private var trimmedUserName: String {
        userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(
        coordinator: SetNameCoordinating,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.userDefaultsStorage = userDefaultsStorage
    }

    func setUserName(_ newValue: String) {
        userName = newValue
        updateValidationState()
    }

    private func updateValidationState() {
        resetErrorState()
        isValid = trimmedUserName.count > 0
    }

    func validateAndContinue(onSuccess: () -> Void) {
        updateValidationState()
        guard isValid else {
            applyErrorState()
            return
        }
        saveUserName(trimmedUserName)
        onSuccess()
    }

    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>, onSuccess: () -> Void) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                applyAppleSignInError()
                return
            }

            let account = AppleSignInAccount(
                credential: credential,
                fallbackUserName: nonEmptyUserName()
            )
            saveAppleLogin(
                accountID: account.accountID,
                userName: account.userName,
                email: account.email
            )
            onSuccess()
        case .failure(let error):
            guard AppleSignInAccount.isCancellation(error).not else { return }
            applyAppleSignInError(error)
        }
    }

    private func applyErrorState() {
        borderState = .error
        errorText = L10n.SignInPage.error
    }

    private func resetErrorState() {
        borderState = .normal
        errorText = ""
    }

    private func applyAppleSignInError(_ error: Error? = nil) {
        borderState = .error
        errorText = AppleSignInAccount.errorMessage(for: error)
    }

    private func nonEmptyUserName() -> String? {
        trimmedUserName.isEmpty ? nil : trimmedUserName
    }

    private func localAccountID() -> String {
        "local:\(UUID().uuidString)"
    }

    private func saveUserName(_ name: String) {
        userDefaultsStorage.save(value: localAccountID(), for: UserDefaultKeys.currentAccountID)
        userDefaultsStorage.save(value: name, for: UserDefaultKeys.userName)
        userDefaultsStorage.removeValue(for: UserDefaultKeys.userEmail)
        saveLoginState()
    }

    private func saveAppleLogin(accountID: String, userName: String?, email: String?) {
        userDefaultsStorage.save(value: accountID, for: UserDefaultKeys.currentAccountID)

        if let userName {
            userDefaultsStorage.save(value: userName, for: UserDefaultKeys.userName)
        }

        if let email {
            userDefaultsStorage.save(value: email, for: UserDefaultKeys.userEmail)
        }

        saveLoginState()
    }

    private func saveLoginState() {
        userDefaultsStorage.save(value: Date(), for: UserDefaultKeys.userCreatedAt)
        userDefaultsStorage.save(value: true, for: UserDefaultKeys.isLogin)
    }

    func goToWelcomePage() {
        coordinator.goToWelcome()
    }
}
