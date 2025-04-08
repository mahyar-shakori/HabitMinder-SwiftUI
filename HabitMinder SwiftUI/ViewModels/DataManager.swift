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

    func fetchAll() -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try context.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch \(T.self): \(error)")
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
            print("❌ Failed to fetch \(T.self) with ID: \(error)")
            return nil
        }
    }

    func save(_ item: T) {
        context.insert(item)
        do {
            try context.save()
        } catch {
            print("❌ Failed to save \(T.self): \(error)")
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
            print("❌ Failed to delete \(T.self): \(error)")
        }
    }

    func update(_ updateBlock: (T) -> Void, forID id: UUID) {
        do {
            let descriptor = FetchDescriptor<T>(
                predicate: #Predicate<T> { $0.id == id }
            )
            guard let item = try context.fetch(descriptor).first else {
                print("⚠️ No item with id \(id) found.")
                return
            }

            updateBlock(item)
            try context.save()

        } catch {
            print("❌ Failed to update \(T.self): \(error)")
        }
    }
}


extension Habit: IdentifiableModel {}

protocol IdentifiableModel {
    var id: UUID { get }
}
