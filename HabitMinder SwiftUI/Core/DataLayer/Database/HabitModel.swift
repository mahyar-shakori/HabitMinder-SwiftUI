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
    var sortOrder: Int
    
    init(id: UUID = .init(), title: String, createdAt: Date = .now, sortOrder: Int = 0) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.sortOrder = sortOrder
    }
}
