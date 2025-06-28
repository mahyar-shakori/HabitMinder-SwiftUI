//
//  CustomButtonStylePreset.swift
//  HabitMinder
//
//  Created by Mahyar on 28/06/2025.
//

import SwiftUI

struct CustomButtonStylePreset {
    
    static func `default`(
        font: Font = .AppFont.rooneySansBold.size(20),
        tintColor: Color = .primary,
        backgroundColor: Color = .clear,
        innerPadding: CustomPadding = .none,
        outerPadding: CustomPadding = .none,
        expandHorizontally: Bool = false,
        shape: AnyShape? = nil,
        isDisabled: Bool = false
    ) -> CustomButtonStyle {

        CustomButtonStyle(
            font: font,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            innerPadding: innerPadding,
            outerPadding: outerPadding,
            expandHorizontally: expandHorizontally,
            shape: shape,
            isDisabled: isDisabled
        )
    }
    
    static func secondary(
        font: Font = .AppFont.rooneySansBold.size(18),
        tintColor: Color = .appWhite,
        backgroundColor: Color = .appWhite,
        innerPadding: CustomPadding = .insets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)),
        outerPadding: CustomPadding = .insets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)),
        expandHorizontally: Bool = false,
        shape: AnyShape? = AnyShape(Capsule()),
        isDisabled: Bool = false
    ) -> CustomButtonStyle {
        
        CustomButtonStyle(
            font: font,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            innerPadding: innerPadding,
            outerPadding: outerPadding,
            expandHorizontally: expandHorizontally,
            shape: shape,
            isDisabled: isDisabled
        )
    }
    
    static func tertiary(
        font: Font = .AppFont.rooneySansBold.size(20),
        tintColor: Color = .white,
        backgroundColor: Color = .appWhite,
        innerPadding: CustomPadding = .standard,
        outerPadding: CustomPadding = .insets(EdgeInsets(top: 0, leading: 32, bottom: 32, trailing: 32)),
        expandHorizontally: Bool = true,
        shape: AnyShape? = AnyShape(Capsule()),
        isDisabled: Bool = false
    ) -> CustomButtonStyle {
        
        CustomButtonStyle(
            font: font,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            innerPadding: innerPadding,
            outerPadding: outerPadding,
            expandHorizontally: expandHorizontally,
            shape: shape,
            isDisabled: isDisabled
        )
    }
}
