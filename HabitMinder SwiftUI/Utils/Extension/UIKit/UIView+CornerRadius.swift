//
//  UIView+CornerRadius.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/8/24.
//

import UIKit

extension UIView {
    func setCornerRadius(to radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
