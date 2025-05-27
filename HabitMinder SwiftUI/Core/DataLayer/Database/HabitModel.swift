//
//  HabitModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import SwiftData

@Model
final class HabitModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date

    init(title: String, createdAt: Date = .now) {
        self.id = UUID()
        self.title = title
        self.createdAt = createdAt
    }
}
