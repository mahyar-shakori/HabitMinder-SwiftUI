//
//  FutureHabitModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation
import SwiftData

@Model
final class FutureHabitModel: IdentifiableModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date

    init(
        id: UUID = .init(),
        title: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
