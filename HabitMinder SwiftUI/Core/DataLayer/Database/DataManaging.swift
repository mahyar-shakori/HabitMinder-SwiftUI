//
//  DataManaging.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/06/2025.
//

import Foundation
import SwiftData

protocol DataManaging {
    associatedtype Entity: PersistentModel & IdentifiableModel
    
    func fetchAll() -> [Entity]
    func fetch(byID id: UUID) -> Entity?
    func save(_ item: Entity)
    func delete(byID id: UUID)
    func deleteAll()
    func update(_ updateBlock: (Entity) -> Void, forID id: UUID)
}
