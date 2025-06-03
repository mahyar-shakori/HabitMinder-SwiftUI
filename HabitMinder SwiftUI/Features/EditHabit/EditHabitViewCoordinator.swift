//
//  EditHabitViewCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

final class EditHabitViewCoordinator: ObservableObject {
    let dismiss: () -> Void
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
    
    func goBack() {
        dismiss() }
}
