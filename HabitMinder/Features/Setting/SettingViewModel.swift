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
    private let userDefaultsStorage: UserDefaultsStoring

    init(
        coordinator: SettingCoordinating,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func setUserName(_ newName: String) {
        userDefaultsStorage.save(value: newName, for: UserDefaultKeys.userName)
        userName = newName
    }
    
    func loadUserName() {
        userName = userDefaultsStorage.fetch(for: UserDefaultKeys.userName) ?? LocalizedStrings.SettingPage.userName
    }
}
