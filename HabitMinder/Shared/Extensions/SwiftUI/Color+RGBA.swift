//
//  Color+RGBA.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/06/2025.
//

import SwiftUI

extension Color {
    var rgbaComponents: [CGFloat]? {
        let cgColor = UIColor(self).cgColor
        guard let components = cgColor.components else {
            return nil
        }

        switch cgColor.numberOfComponents {
        case 4:
            return [components[0], components[1], components[2], components[3]]
        case 2:
            return [components[0], components[0], components[0], components[1]]
        default:
            return nil
        }
    }
}
