//
//  DispatchQueue+Delay.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

extension DispatchQueue {
    static func delay(_ seconds: TimeInterval, on queue: DispatchQueue = .main, completion: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}
