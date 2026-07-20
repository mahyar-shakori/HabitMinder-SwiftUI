//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation
import Observation

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
    
    private func applyErrorState() {
        borderState = .error
        errorText = LocalizedStrings.SetNamePage.error
    }
    
    private func resetErrorState() {
        borderState = .normal
        errorText = ""
    }
    
    private func saveUserName(_ name: String) {
        userDefaultsStorage.save(value: name, for: UserDefaultKeys.userName)
        userDefaultsStorage.save(value: true, for: UserDefaultKeys.isLogin)
    }
    
    func goToWelcomePage() {
        coordinator.goToWelcome()
    }
}
