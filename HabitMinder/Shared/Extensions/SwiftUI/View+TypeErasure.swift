//
//  View+TypeErasure.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
