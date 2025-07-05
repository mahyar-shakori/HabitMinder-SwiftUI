//
//  DataManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import SwiftData

final class DataManager: DataManaging {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll<T: ModelEntity>(_ type: T.Type) -> [T] {
        do {
            return try context.fetch(FetchDescriptor<T>())
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to fetch all \(String(describing: T.self)): \(error.localizedDescription)")
#endif
            return []
        }
    }

    func fetch<T: ModelEntity>(byID id: UUID, _ type: T.Type) -> T? {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        do {
            return try context.fetch(descriptor).first
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to fetch \(String(describing: T.self)) with ID \(id): \(error.localizedDescription)")
#endif
            return nil
        }
    }

    func save<T: ModelEntity>(_ item: T) {
        context.insert(item)
        do {
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to save \(String(describing: T.self)): \(error.localizedDescription)")
#endif
        }
    }

    func delete<T: ModelEntity>(byID id: UUID, _ type: T.Type) {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        do {
            let results = try context.fetch(descriptor)
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to delete \(String(describing: T.self)) with ID \(id): \(error.localizedDescription)")
#endif
        }
    }

    func deleteAll<T: ModelEntity>(_ type: T.Type) {
        do {
            let allItems = try context.fetch(FetchDescriptor<T>())
            allItems.forEach { context.delete($0) }
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to delete all \(String(describing: T.self)): \(error.localizedDescription)")
#endif
        }
    }

    func update<T: ModelEntity>(
        _ updateBlock: (T) -> Void,
        forID id: UUID,
        _ type: T.Type
    ) {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        do {
            guard let item = try context.fetch(descriptor).first else {
#if DEBUG
                AppLogger.data.warning("No item with ID \(id.uuidString, privacy: .private) found for update.")
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
