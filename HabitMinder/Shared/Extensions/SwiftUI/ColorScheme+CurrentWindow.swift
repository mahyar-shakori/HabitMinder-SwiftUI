//
//  ColorScheme+CurrentWindow.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

extension ColorScheme {
    @MainActor
    static var currentWindow: ColorScheme? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .traitCollection
            .userInterfaceStyle
            .colorScheme
    }
}

private extension UIUserInterfaceStyle {
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .unspecified:
            return nil
        @unknown default:
            return nil
        }
    }
}
