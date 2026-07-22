//
//  View+liquidGlass.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func liquidGlass<S: Shape, FallbackStyle: ShapeStyle>(
        tint: Color? = nil,
        in shape: S,
        interactive: Bool = true,
        fallback: FallbackStyle
    ) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(
                interactive ? .regular.tint(tint).interactive() : .regular.tint(tint),
                in: shape
            )
            .contentShape(shape)
        } else {
            background(fallback, in: shape)
                .clipShape(shape)
                .contentShape(shape)
        }
    }

    @ViewBuilder
    func primaryButtonChrome(tint: Color, controlSize: ControlSize) -> some View {
        if #available(iOS 26.0, *) {
            buttonStyle(.glassProminent)
                .controlSize(controlSize)
                .buttonBorderShape(.capsule)
                .tint(tint)
        } else {
            buttonStyle(.borderedProminent)
                .controlSize(controlSize)
                .buttonBorderShape(.capsule)
                .tint(tint)
        }
    }
}
