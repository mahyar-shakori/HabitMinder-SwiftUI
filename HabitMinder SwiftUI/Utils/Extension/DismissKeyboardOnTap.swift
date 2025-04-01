//
//  DismissKeyboardOnTap.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct DismissKeyboardOnTap: ViewModifier {
    @FocusState.Binding var isFocused: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }
            content
        }
    }
}

extension View {
    func dismissKeyboardOnTap(focus: FocusState<Bool>.Binding) -> some View {
        self.modifier(DismissKeyboardOnTap(isFocused: focus))
    }
}
