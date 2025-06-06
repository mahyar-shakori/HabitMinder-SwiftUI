//
//  SettingCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/05/2025.
//

import Foundation

final class SettingCoordinator: ObservableObject {
    private let dismiss: () -> Void
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
    
    func goBack() {
        dismiss()
    }
}
