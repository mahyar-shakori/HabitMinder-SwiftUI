//
//  LayoutStyle.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import Foundation

enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 14
    static let xLarge: CGFloat = 16
    static let x2Large: CGFloat = 18
    static let x3Large: CGFloat = 20
}

enum Opacity {
    static let quiet: CGFloat = 0.08
    static let subtle: CGFloat = 0.18
    static let fieldBorder: CGFloat = 0.22
    static let subtleBorder: CGFloat = 0.35
    static let secondaryTint: CGFloat = 0.4
    static let iconBackground: CGFloat = 0.45
    static let completedIconBackground: CGFloat = 0.55
    static let badgeBackground: CGFloat = 0.6
    static let sectionTitle: CGFloat = 0.72
    static let formHeader: CGFloat = 0.75
    static let toastBackground: CGFloat = 0.8
}

enum LineWidth {
    static let thin: CGFloat = 1
    static let medium: CGFloat = 2
}

enum Scale {
    static let minimumText: CGFloat = 0.8
    static let normal: CGFloat = 1
    static let medium: CGFloat = 1.5
    static let progress: CGFloat = 1.7
    static let emphasizedProgress: CGFloat = 1.8
}

enum Size {
    static let xSmall: CGFloat = 10
    static let small: CGFloat = 20
    static let medium: CGFloat = 24
    static let buttonIcon: CGFloat = 26
    static let large: CGFloat = 30
    static let xLarge: CGFloat = 36
    static let x2Large: CGFloat = 40
    static let x3Large: CGFloat = 48
    static let x4Large: CGFloat = 56
    static let x5Large: CGFloat = 60
    static let x6Large: CGFloat = 70
    static let emptyImage: CGFloat = 150
    static let largeEmptyImage: CGFloat = 180
}

enum FontSize {
    static let xSmall: CGFloat = 11
    static let small: CGFloat = 12
    static let medium: CGFloat = 13
    static let large: CGFloat = 14
    static let xLarge: CGFloat = 15
    static let x2Large: CGFloat = 16
    static let x3Large: CGFloat = 17
    static let x4Large: CGFloat = 18
    static let x5Large: CGFloat = 20
    static let x6Large: CGFloat = 21
    static let x7Large: CGFloat = 22
    static let x8Large: CGFloat = 24
    static let x9Large: CGFloat = 28
}

enum Time {
    static let short: CGFloat = 0.3
    static let day: TimeInterval = 60 * 60 * 24
}

enum StrokeDash {
    static let subtle: [CGFloat] = [Spacing.x2Small - LineWidth.thin, Spacing.x2Small - LineWidth.thin]
}

enum LayoutCount {
    static let zero = 0
    static let four = 4
    static let nearFutureDayLimit = 7
    static let quoteCharacterLimit = 100
    static let paddedTimeComponentThreshold = 10
    static let previewFutureHabitDelayDays: TimeInterval = 3
}
