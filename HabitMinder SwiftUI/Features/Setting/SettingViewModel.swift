//
//  SettingViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published private(set) var userName = ""
    
    private let userNameStorage = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)
    private let coordinator: SettingCoordinator
    
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    func setUserName(_ newName: String) {
        userNameStorage.save(value: newName)
        userName = newName
    }
    
    func loadUserName() {
        userName = userNameStorage.fetch() ?? LocalizedStrings.SettingPage.userName
    }
}
