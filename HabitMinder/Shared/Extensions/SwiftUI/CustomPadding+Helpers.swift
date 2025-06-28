//
//  CustomPadding+Helpers.swift
//  HabitMinder
//
//  Created by Mahyar on 28/06/2025.
//

import SwiftUI

extension CustomPadding {
    static func insets(_ all: CGFloat) -> CustomPadding {
        .insets(EdgeInsets(top: all, leading: all, bottom: all, trailing: all))
    }
}
