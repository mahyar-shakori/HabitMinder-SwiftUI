//
//  AppProfileButton.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct AppProfileButton<Content: View>: View {
    private let action: () -> Void
    private let content: () -> Content

    init(
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: action) {
            content()
                .frame(width: Size.x3Large, height: Size.x3Large)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .liquidGlass(in: Circle(), fallback: .clear)
    }
}
