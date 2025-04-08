//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

final class SetNameViewModel: ObservableObject {
    @Published var userName = "" {
        didSet {
            updateValidationState()
        }
    }
    @Published var userNameBorderColor: Color = .accent
    @Published var userNameBorderSize = 1.0
    @Published var errorText = ""
    @Published var continueButtonColor: Color = .appSecondary
    
    func validateAndContinue(onSuccess: () -> Void) {
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            applyErrorState()
            return
        }
        saveUserName()
        onSuccess()
    }
    
    private func updateValidationState() {
        resetErrorState()
        
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = trimmedName.count > 1
        
        continueButtonColor = isValid ? .accent : .secondary
    }
    
    private func applyErrorState() {
        userNameBorderColor = .red
        userNameBorderSize = 2
        errorText = LocalizedStrings.SetNamePage.error
        continueButtonColor = .appSecondary
    }
    
    private func resetErrorState() {
        userNameBorderColor = .accent
        userNameBorderSize = 1
        errorText = ""
    }
    
    private func saveUserName() {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: UserDefaultKeys.userName)
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: UserDefaultKeys.isLogin)
        
        userNameStorage.save(value: userName)
        loginStorage.save(value: true)
    }
}
