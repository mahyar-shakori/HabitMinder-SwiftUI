//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import AuthenticationServices
import Foundation
import Observation

@MainActor
@Observable
final class SetNameViewModel {
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

    func handleAppleSignInRequestStarted() {
#if DEBUG
        AppLogger.auth.notice("Apple sign in request started")
#endif
    }

    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>, onSuccess: () -> Void) {
#if DEBUG
        AppLogger.auth.notice("Apple sign in completed")
#endif
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                applyAppleSignInError()
                return
            }

#if DEBUG
            AppLogger.auth.notice("Apple credential email: \(credential.email ?? "nil", privacy: .public)")
#endif
            saveAppleLogin(
                accountID: appleAccountID(from: credential),
                userName: appleDisplayName(from: credential) ?? nonEmptyUserName() ?? "Apple User",
                email: nonEmptyEmail(from: credential)
            )
            onSuccess()
        case .failure(let error):
            guard isAppleSignInCancellation(error).not else { return }
            applyAppleSignInError(error)
        }
    }

    private func applyErrorState() {
        borderState = .error
        errorText = L10n.SetNamePage.error
    }

    private func resetErrorState() {
        borderState = .normal
        errorText = ""
    }

    private func applyAppleSignInError(_ error: Error? = nil) {
        borderState = .error
        errorText = appleSignInErrorMessage(for: error)
    }

    private func appleDisplayName(from credential: ASAuthorizationAppleIDCredential) -> String? {
        let displayName = PersonNameComponentsFormatter().string(from: credential.fullName ?? PersonNameComponents())
        let trimmedDisplayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmedDisplayName.isEmpty ? nil : trimmedDisplayName
    }

    private func nonEmptyUserName() -> String? {
        trimmedUserName.isEmpty ? nil : trimmedUserName
    }

    private func nonEmptyEmail(from credential: ASAuthorizationAppleIDCredential) -> String? {
        let email = credential.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return email.isEmpty ? nil : email
    }

    private func appleAccountID(from credential: ASAuthorizationAppleIDCredential) -> String {
        "apple:\(credential.user)"
    }

    private func localAccountID() -> String {
        "local:\(UUID().uuidString)"
    }

    private func appleSignInErrorMessage(for error: Error?) -> String {
        guard let error else { return L10n.Alert.Network.unknownError }

        #if DEBUG
        return "Apple Sign In failed: \(error.localizedDescription)"
        #else
        return L10n.Alert.Network.unknownError
        #endif
    }

    private func isAppleSignInCancellation(_ error: Error) -> Bool {
        guard let authorizationError = error as? ASAuthorizationError else { return false }
        return authorizationError.code == .canceled
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
