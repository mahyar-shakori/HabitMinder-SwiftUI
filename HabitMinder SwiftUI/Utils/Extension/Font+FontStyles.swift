//
//  Font+FontStyles.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

extension Font {
    struct RooneySans {
        private let fontName: String
        
        init(name: String) {
            self.fontName = name
        }
        
        func size(_ size: CGFloat) -> Font {
            Font.custom(fontName, size: size)
        }
    }
    
    static let rooneySansRegular: RooneySans = RooneySans(name: "RooneySans-Regular")
    static let rooneySansBold: RooneySans = RooneySans(name: "RooneySans-Bold")
}
