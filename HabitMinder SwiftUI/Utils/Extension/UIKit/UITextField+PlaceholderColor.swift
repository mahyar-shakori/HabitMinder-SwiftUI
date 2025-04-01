//
//  UITextField+PlaceholderColor.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/8/24.
//

import UIKit

extension UITextField {
    var placeholderColor: UIColor {
        get {
            attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            let currentText = placeholder ?? ""
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            attributedPlaceholder = NSAttributedString(string: currentText, attributes: attributes)
        }
    }
}
