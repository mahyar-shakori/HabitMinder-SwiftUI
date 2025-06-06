//
//  AddHabitCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

final class AddHabitCoordinator: ObservableObject {
    private let dismiss: () -> Void
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
    
    func goBack() {
        dismiss()
    }
}
