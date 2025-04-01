//
//  UIView+ShowToast.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 12/26/24.
//

import UIKit

extension UIView {
    func showToast(with toastLabel: UILabel, showDuration: TimeInterval = 0.5, showDelay: TimeInterval = 0.0, hideDuration: TimeInterval = 0.5, hideDelay: TimeInterval = 2.0) {
        
        if toastLabel.superview == nil {
            addSubview(toastLabel)
        }
        
        toastLabel.center = center
        toastLabel.alpha = 0.0
        
        UIView.animate(withDuration: showDuration, delay: showDelay, options: .curveEaseIn,
                       animations: {
            toastLabel.alpha = 1.0
        },
                       completion: { _ in
            UIView.animate(withDuration: hideDuration, delay: hideDelay, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            },
                           completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
