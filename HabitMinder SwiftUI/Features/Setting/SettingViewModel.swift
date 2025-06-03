//
//  SettingViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published var userName = ""
   
    func load() {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)        
        userName = userNameStorage.fetch() ?? LocalizedStrings.SettingPage.userName
    }
    
    func changeUserName() {
        let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)
        userNameStorage.save(value: userName)
    }
}
