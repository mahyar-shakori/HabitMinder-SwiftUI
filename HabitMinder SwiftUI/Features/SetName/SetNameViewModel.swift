//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class SetNameViewModel: ObservableObject {
    @Published private(set) var uiState = SetNameUIState()
    
    private let coordinator: SetNameCoordinator
    
    private var trimmedUserName: String {
        uiState.userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(coordinator: SetNameCoordinator) {
        self.coordinator = coordinator
    }
    
    func setUserName(_ newValue: String) {
        uiState.userName = newValue
        updateValidationState()
    }
    
    private func updateValidationState() {
        resetErrorState()
        uiState.isValid = trimmedUserName.count > 0
    }
    
    func validateAndContinue(onSuccess: () -> Void) {
        updateValidationState()
        guard uiState.isValid else {
            applyErrorState()
            return
        }
        saveUserName(trimmedUserName)
        onSuccess()
    }
    
    private func applyErrorState() {
        uiState.borderState = .error
        uiState.errorText = LocalizedStrings.SetNamePage.error
    }
    
    private func resetErrorState() {
        uiState.borderState = .normal
        uiState.errorText = ""
    }
    
    private func saveUserName(_ name: String) {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        userNameStorage.save(value: name)
        loginStorage.save(value: true)
    }
    
    func goToWelcomePage() {
        coordinator.goToWelcome()
    }
}
