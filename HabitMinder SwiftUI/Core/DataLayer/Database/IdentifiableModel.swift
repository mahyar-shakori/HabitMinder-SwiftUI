//
//  UUIDIdentifiable.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 12/04/2025.
//

import Foundation

protocol IdentifiableModel {
    var id: UUID { get }
}

extension HabitModel: IdentifiableModel {}
