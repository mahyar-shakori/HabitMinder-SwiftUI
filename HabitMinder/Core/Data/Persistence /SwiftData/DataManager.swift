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

    private var currentOwnerID: String {
        UserDefaults.standard.string(forKey: UserDefaultKeys.currentAccountID.rawValue) ?? ""
    }

    func fetchAll<T: ModelEntity>(_ type: T.Type) -> [T] {
        let ownerID = currentOwnerID
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.ownerID == ownerID }
        )
        do {
            let items = try context.fetch(descriptor)
            return items
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to fetch all \(String(describing: T.self)) for ownerID=\(ownerID, privacy: .public): \(error.localizedDescription)")
#endif
            return []
        }
    }

    func fetch<T: ModelEntity>(
        byID id: UUID,
        _ type: T.Type
    ) -> T? {
        let ownerID = currentOwnerID
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id && $0.ownerID == ownerID }
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
        let ownerID = currentOwnerID
        guard ownerID.isEmpty.not else {
#if DEBUG
            AppLogger.data.error("Skipped saving \(String(describing: T.self)) because currentAccountID is empty")
#endif
            return
        }

        var item = item
        item.ownerID = ownerID
        context.insert(item)
        do {
            try context.save()
        } catch {
#if DEBUG
            AppLogger.data.error("Failed to save \(String(describing: T.self)) for ownerID=\(ownerID, privacy: .public): \(error.localizedDescription)")
#endif
        }
    }

    func delete<T: ModelEntity>(
        byID id: UUID,
        _ type: T.Type
    ) {
        let ownerID = currentOwnerID
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id && $0.ownerID == ownerID }
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
        let ownerID = currentOwnerID
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.ownerID == ownerID }
        )
        do {
            let allItems = try context.fetch(descriptor)
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
        let ownerID = currentOwnerID
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id && $0.ownerID == ownerID }
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
