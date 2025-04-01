//
//  DispatchQueue+Delay.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/9/24.
//

import Dispatch

extension DispatchQueue {
    static func delay(_ seconds: Double, queue: DispatchQueue = .main, completion: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}
