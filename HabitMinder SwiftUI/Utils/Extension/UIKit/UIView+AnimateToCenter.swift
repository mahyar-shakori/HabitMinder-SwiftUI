//
//  UIView+AnimateToCenter.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/7/24.
//

import UIKit

extension UIView {
    func animateToCenter(of containerView: UIView, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        frame.origin.x = -bounds.width / 2
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.center.x = containerView.bounds.midX
        }, completion: completion)
    }
}
