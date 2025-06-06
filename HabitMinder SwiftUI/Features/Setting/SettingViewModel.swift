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
        changeUserName()
    }
    
    func load() {
        userName = userNameStorage.fetch() ?? LocalizedStrings.SettingPage.userName
    }
    
    private func changeUserName() {
        userNameStorage.save(value: userName)
    }
}
