//
//  UIView+isVisible.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 2/8/25.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}
