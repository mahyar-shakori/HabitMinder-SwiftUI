//
//  SettingsRowButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct SettingsRowButton<Content: View>: View {
    let action: () -> Void
    let content: Content

    init(
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            content
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
