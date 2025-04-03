//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

final class SetNameViewModel: ObservableObject {
    @Published var userName: String = "" {
        didSet {
            updateValidationState()
        }
    }
    @Published var borderColor: Color = .accent
    @Published var borderSize = 1.0
    @Published var errorText = ""
    @Published var buttonColor: Color = .appSecondary
    
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
        let isValid = trimmedName.count > 1
        
        buttonColor = isValid ? .accent : .secondary
    }
    
    private func applyErrorState() {
        borderColor = .red
        borderSize = 2
        errorText = LocalizedStrings.SetNamePage.error
        buttonColor = .appSecondary
    }
    
    private func resetErrorState() {
        borderColor = .accent
        borderSize = 1
        errorText = ""
    }
    
    private func saveUserName() {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: UserDefaultKeys.userName)
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: UserDefaultKeys.isLogin)
        
        userNameStorage.save(value: userName)
        loginStorage.save(value: true)
    }
}
