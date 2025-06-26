//
//  View+DismissKeyboard.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

extension View {
    func dismissKeyboard(focus: FocusState<Bool>.Binding) -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
                focus.wrappedValue = false
            }
    }
}
