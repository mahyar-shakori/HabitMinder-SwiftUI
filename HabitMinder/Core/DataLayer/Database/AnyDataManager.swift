//
//  AnyDataManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/06/2025.
//

import Foundation
import SwiftData

final class AnyDataManager<T: PersistentModel & IdentifiableModel>: DataManaging {
    private let _fetchAll: () -> [T]
    private let _fetch: (UUID) -> T?
    private let _save: (T) -> Void
    private let _delete: (UUID) -> Void
    private let _deleteAll: () -> Void
    private let _update: ((T) -> Void, UUID) -> Void

    init<M: DataManaging>(_ manager: M) where M.Entity == T {
        _fetchAll = manager.fetchAll
        _fetch = manager.fetch
        _save = manager.save
        _delete = manager.delete
        _deleteAll = manager.deleteAll
        _update = manager.update
    }

    func fetchAll() -> [T] { _fetchAll() }
    func fetch(byID id: UUID) -> T? { _fetch(id) }
    func save(_ item: T) { _save(item) }
    func delete(byID id: UUID) { _delete(id) }
    func deleteAll() { _deleteAll() }
    func update(_ updateBlock: (T) -> Void, forID id: UUID) { _update(updateBlock, id) }
}
