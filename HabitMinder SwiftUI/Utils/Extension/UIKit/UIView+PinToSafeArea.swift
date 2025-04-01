//
//  UIView+PinToSafeArea.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/5/25.
//

import UIKit

extension UIView {
    func pinToSafeArea() {
        guard let superview = superview else {
            assertionFailure("View must have a superview before anchoring")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
