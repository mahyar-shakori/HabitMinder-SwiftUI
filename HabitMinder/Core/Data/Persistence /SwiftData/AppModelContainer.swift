//
//  AppModelContainer.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import SwiftData

enum AppModelContainer {
    static func make() throws -> ModelContainer {
        try makeModelContainer(cloudKitDatabase: .private(AppCloudKit.containerIdentifier))
    }

    static func makeInMemory() throws -> ModelContainer {
        try makeModelContainer(
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )
    }

    private static var schema: Schema {
        Schema([
            HabitModel.self,
            HabitHistoryModel.self
        ])
    }

    private static func makeModelContainer(
        isStoredInMemoryOnly: Bool = false,
        cloudKitDatabase: ModelConfiguration.CloudKitDatabase
    ) throws -> ModelContainer {
        let schema = schema
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            cloudKitDatabase: cloudKitDatabase
        )

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }
}
