//
//  AppPrimaryButtonSize.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

enum AppPrimaryButtonSize {
    case regular
    case large

    var fontSize: CGFloat {
        switch self {
        case .regular:
            FontSize.medium
        case .large:
            FontSize.x3Large
        }
    }

    var controlSize: ControlSize {
        switch self {
        case .regular:
            .regular
        case .large:
            .large
        }
    }
}
