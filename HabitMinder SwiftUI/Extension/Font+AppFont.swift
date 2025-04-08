//
//  Font+AppFont.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

extension Font {
    enum AppFont: String {
        case rooneySansRegular = "RooneySans-Regular"
        case rooneySansBold = "RooneySans-Bold"
        
        func size(_ size: CGFloat) -> Font {
            Font.custom(self.rawValue, size: size)
        }
    }
}
