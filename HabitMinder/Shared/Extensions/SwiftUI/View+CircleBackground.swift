//
//  View+CircleBackground.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func circleBackground(_ tint: Color = .appPrimary) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular.tint(tint).interactive(), in: Circle())
                .contentShape(Circle())
        } else {
            background(tint)
                .clipShape(Circle())
        }
    }
}
