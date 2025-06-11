//
//  SettingViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published private(set) var userName = ""
    
    private let coordinator: SettingCoordinating
    private let userNameStorage: AnyUserDefaultsStorage<String>
    
    init(
        coordinator: SettingCoordinating,
        userNameStorage: AnyUserDefaultsStorage<String>
    ) {
        self.coordinator = coordinator
        self.userNameStorage = userNameStorage
    }
    
    func setUserName(_ newName: String) {
        userNameStorage.save(value: newName)
        userName = newName
    }
    
    func loadUserName() {
        userName = userNameStorage.fetch() ?? LocalizedStrings.SettingPage.userName
    }
}
