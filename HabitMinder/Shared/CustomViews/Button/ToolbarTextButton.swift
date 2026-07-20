//
//  ToolbarTextButton.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct ToolbarTextButton: View {
    let title: String
    let weight: Font.Weight
    let action: () -> Void

    init(
        _ title: String,
        weight: Font.Weight = .regular,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.weight = weight
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundStyle(.blue)
        }
        .buttonStyle(.plain)
    }

    private var font: Font {
        weight == .bold ? .AppFont.rooneySansBold.size(FontSize.x4Large) : .AppFont.rooneySansRegular.size(FontSize.x4Large)
    }
}
