//
//  CustomButton.swift
//  HabitMinder
//
//  Created by Mahyar on 26/06/2025.
//

import SwiftUI

struct CustomButton<Label: View>: View {
    let action: () -> Void
    let style: CustomButtonStyle
    let label: Label

    init(
        style: CustomButtonStyle = CustomButtonStylePreset.tertiary(),
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.style = style
        self.label = label()
    }
    
    var body: some View {
        Button(action: action) {
            label
                .font(style.font)
                .tint(style.tintColor)
                .applyButtonPadding(style.innerPadding)
                .frame(maxWidth: style.expandHorizontally ? .infinity : nil)
                .background {
                    if let shape = style.shape, let bg = style.backgroundColor {
                        shape.fill(bg)
                    } else if let bg = style.backgroundColor {
                        bg
                    }
                }
        }
        .applyButtonPadding(style.outerPadding)
        .disabled(style.isDisabled)
    }
}

#Preview {
    CustomButton(style: CustomButtonStylePreset.tertiary(
        backgroundColor: .appPrimary
    )) {
        print("Default tapped")
    } label: {
        Text("Default")
    }
}
