//
//  Int+CGSizeConvertible.swift
//  HabitMinder
//
//  Created by Mahyar on 28/06/2025.
//

import Foundation

extension Int {
    var asCGSize: CGSize {
        CGSize(width: CGFloat(self), height: CGFloat(self))
    }
}
