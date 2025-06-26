//
//  Task+Delay.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func delay(seconds: TimeInterval = 1) async {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}
