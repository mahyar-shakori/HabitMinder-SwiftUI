//
//  HabitData.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import Foundation

struct HabitData: Hashable {
    let title: String
    let daysLeft: Int

    var toDictionary: [String: Any] {
        return [
            "title": title,
            "daysLeft": daysLeft
        ]
    }
}
