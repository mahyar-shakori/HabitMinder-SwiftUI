//
//  DataManager.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/04/2025.
//

import Foundation
import SwiftData
import OSLog

final class DataManager<T: PersistentModel & IdentifiableModel> {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try context.fetch(descriptor)
        } catch {
            Logger.data.error("Failed to fetch \(String(describing: T.self)): \(error.localizedDescription)")
            return []
        }
    }

    func fetch(byID id: UUID) -> T? {
        do {
            let descriptor = FetchDescriptor<T>(
                predicate: #Predicate<T> { $0.id == id }
            )
            return try context.fetch(descriptor).first
        } catch {
            Logger.data.error("Failed to fetch \(String(describing: T.self)) with ID \(id.uuidString): \(error.localizedDescription)")
            return nil
        }
    }

    func save(_ item: T) {
        context.insert(item)
        do {
            try context.save()
        } catch {
            Logger.data.error("Failed to save \(String(describing: T.self)): \(error.localizedDescription)")
        }
    }

    func delete(byID id: UUID) {
        do {
            let descriptor = FetchDescriptor<T>(
                predicate: #Predicate<T> { $0.id == id }
            )
            let results = try context.fetch(descriptor)
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
            Logger.data.error("Failed to delete \(String(describing: T.self)): \(error.localizedDescription)")
        }
    }

    func update(_ updateBlock: (T) -> Void, forID id: UUID) {
        do {
            let descriptor = FetchDescriptor<T>(
                predicate: #Predicate<T> { $0.id == id }
            )
            guard let item = try context.fetch(descriptor).first else {
                Logger.data.warning("No item with id \(id.uuidString, privacy: .private) found for update.")
                return
            }
            updateBlock(item)
            try context.save()
        } catch {
            Logger.data.error("Failed to update \(String(describing: T.self)): \(error.localizedDescription)")
        }
    }
}
