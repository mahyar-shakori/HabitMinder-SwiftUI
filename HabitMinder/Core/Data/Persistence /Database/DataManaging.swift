//
//  DataManaging.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/06/2025.
//

import Foundation
import SwiftData

typealias ModelEntity = PersistentModel & IdentifiableModel

protocol DataManaging {
    func fetchAll<T: ModelEntity>(_ type: T.Type) -> [T]
    func fetch<T: ModelEntity>(byID id: UUID, _ type: T.Type) -> T?
    func save<T: ModelEntity>(_ item: T)
    func delete<T: ModelEntity>(byID id: UUID, _ type: T.Type)
    func deleteAll<T: ModelEntity>(_ type: T.Type)
    func update<T: ModelEntity>(
        _ updateBlock: (T) -> Void,
        forID id: UUID,
        _ type: T.Type
    )
}
