//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class SetNameViewModel: ObservableObject {
    @Published var userName: String = "" {
        didSet { updateValidationState() }
    }
    @Published private(set) var uiState = SetNameUIState()
    
    func validateAndContinue(onSuccess: () -> Void) {
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isNotEmpty else {
            applyErrorState()
            return
        }
        saveUserName()
        onSuccess()
    }
    
    private func updateValidationState() {
        resetErrorState()
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        uiState.isValid = trimmedName.count > 1
    }
    
    private func applyErrorState() {
        uiState.borderState = .error
        uiState.errorText = LocalizedStrings.SetNamePage.error
    }
    
    private func resetErrorState() {
        uiState.borderState = .normal
        uiState.errorText = ""
    }
    
    private func saveUserName() {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        userNameStorage.save(value: userName)
        loginStorage.save(value: true)
    }
}
