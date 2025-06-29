//
//  View+CustomPadding .swift
//  HabitMinder
//
//  Created by Mahyar on 29/06/2025.
//

import SwiftUI

enum CustomPadding {
    case none
    case standard
    case insets(EdgeInsets)
}

extension CustomPadding {
    static func insets(_ all: CGFloat) -> CustomPadding {
        .insets(EdgeInsets(top: all, leading: all, bottom: all, trailing: all))
    }
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
