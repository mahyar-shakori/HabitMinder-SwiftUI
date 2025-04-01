//
//  SetNameViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

class SetNameViewModel: ObservableObject {
   
    @Published var name: String = "" {
        didSet {
                borderColor = .accent
                borderSize = 1
                errorText = ""
            if name.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 {
                buttonColor = .accent
            } else {
                buttonColor = .secondary
            }
        }
    }
    @Published var borderColor: Color = .accent
    @Published var borderSize = 1.0
    @Published var errorText = ""
    @Published var buttonColor: Color = .appSecondary
    @Published var shouldNavigate = false
    
    func validateAndContinue(onSuccess: () -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            borderColor = .red
            borderSize = 2
            errorText = LocalizedStrings.SetNamePage.errorLabel
            buttonColor = .appSecondary
        } else {
            saveUserName()
            onSuccess()
        }
    }
    
    private func saveUserName() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(true, forKey: "isLogin")
    }
}
