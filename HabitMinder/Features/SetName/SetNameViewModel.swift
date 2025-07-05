//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class SetNameViewModel: ObservableObject {
    @Published private(set) var uiState = SetNameUIState()
    
    private let coordinator: SetNameCoordinating
    private let userDefaultsStorage: UserDefaultsStoring
    
    private var trimmedUserName: String {
        uiState.userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(
        coordinator: SetNameCoordinating,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.userDefaultsStorage = userDefaultsStorage
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
        userDefaultsStorage.save(value: name, for: UserDefaultKeys.userName)
        userDefaultsStorage.save(value: true, for: UserDefaultKeys.isLogin)
    }
    
    func goToWelcomePage() {
        coordinator.goToWelcome()
    }
}
