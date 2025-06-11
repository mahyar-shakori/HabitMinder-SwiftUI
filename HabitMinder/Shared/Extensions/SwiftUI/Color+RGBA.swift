//
//  Color+RGBA.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/06/2025.
//

import SwiftUI

extension Color {
    var rgbaComponents: [CGFloat]? {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return [r, g, b, a]
    }
}
