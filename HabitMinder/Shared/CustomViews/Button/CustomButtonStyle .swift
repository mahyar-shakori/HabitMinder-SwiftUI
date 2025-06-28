//
//  CustomButtonStyle .swift
//  HabitMinder
//
//  Created by Mahyar on 28/06/2025.
//

import SwiftUI

struct CustomButtonStyle {
    let font: Font
    let tintColor: Color
    let backgroundColor: Color?
    let innerPadding: CustomPadding
    let outerPadding: CustomPadding
    let expandHorizontally: Bool
    let shape: AnyShape?
    let isDisabled: Bool
}

enum CustomPadding {
    case none
    case standard
    case insets(EdgeInsets)
}

extension View {
    @ViewBuilder
    func applyButtonPadding(_ padding: CustomPadding) -> some View {
        switch padding {
        case .none:
            self
        case .standard:
            self.padding()
        case .insets(let insets):
            self.padding(insets)
        }
    }
}
