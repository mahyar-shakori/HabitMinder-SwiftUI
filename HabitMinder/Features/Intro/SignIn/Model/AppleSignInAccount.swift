//
//  AppleSignInAccount.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import Foundation
import AuthenticationServices

struct AppleSignInAccount {
    let accountID: String
    let userName: String
    let email: String?

    init(credential: ASAuthorizationAppleIDCredential, fallbackUserName: String?) {
        accountID = "apple:\(credential.user)"
        userName = Self.displayName(from: credential) ?? fallbackUserName ?? "Apple User"
        email = Self.nonEmptyEmail(from: credential)
    }

    static func errorMessage(for error: Error?) -> String {
        guard let error else { return L10n.Alert.Network.unknownError }

        #if DEBUG
        return "Apple Sign In failed: \(error.localizedDescription)"
        #else
        return L10n.Alert.Network.unknownError
        #endif
    }

    static func isCancellation(_ error: Error) -> Bool {
        guard let authorizationError = error as? ASAuthorizationError else { return false }
        return authorizationError.code == .canceled
    }

    private static func displayName(from credential: ASAuthorizationAppleIDCredential) -> String? {
        let displayName = PersonNameComponentsFormatter().string(from: credential.fullName ?? PersonNameComponents())
        let trimmedDisplayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmedDisplayName.isEmpty ? nil : trimmedDisplayName
    }

    private static func nonEmptyEmail(from credential: ASAuthorizationAppleIDCredential) -> String? {
        let email = credential.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return email.isEmpty ? nil : email
    }
}

