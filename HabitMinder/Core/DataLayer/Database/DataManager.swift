//
//  DataManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import SwiftData

final class DataManager<T: PersistentModel & IdentifiableModel> {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    private func makeFetchAllDescriptor() -> FetchDescriptor<T> {
        return FetchDescriptor<T>()
    }
    
    private func makeFetchDescriptor(forID id: UUID) -> FetchDescriptor<T> {
        return FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
    }
    
    func fetchAll() -> [T] {
        do {
            return try context.fetch(makeFetchAllDescriptor())
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to fetch \(String(describing: T.self)): \(error.localizedDescription)")
#endif
            return []
        }
    }
    
    func fetch(byID id: UUID) -> T? {
        do {
            return try context.fetch(makeFetchDescriptor(forID: id)).first
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to fetch \(String(describing: T.self)) with ID \(id.uuidString): \(error.localizedDescription)")
#endif
            return nil
        }
    }
    
    func save(_ item: T) {
        context.insert(item)
        do {
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to save \(String(describing: T.self)): \(error.localizedDescription)")
#endif
        }
    }
    
    func delete(byID id: UUID) {
        do {
            let results = try context.fetch(makeFetchDescriptor(forID: id))
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to delete \(String(describing: T.self)): \(error.localizedDescription)")
#endif
        }
    }
    
    func deleteAll() {
        do {
            let allItems = try context.fetch(makeFetchAllDescriptor())
            allItems.forEach { context.delete($0) }
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to delete all \(String(describing: T.self)) records: \(error.localizedDescription)")
#endif
        }
    }
    
    func update(
        _ updateBlock: (T) -> Void,
        forID id: UUID
    ) {
        do {
            guard let item = try context.fetch(makeFetchDescriptor(forID: id)).first else {
#if DEBUG
                AppLogger.data.warning("No item with id \(id.uuidString, privacy: .private) found for update.")
#endif
                return
            }
            updateBlock(item)
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to update \(String(describing: T.self)): \(error.localizedDescription)")
#endif
        }
    }
}

extension DataManager: DataManaging {
    typealias Entity = T
}
