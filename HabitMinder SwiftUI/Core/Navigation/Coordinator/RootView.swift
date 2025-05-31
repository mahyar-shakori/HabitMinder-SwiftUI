//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = MainCoordinator()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: NavigationItem.self) { item in
                    coordinator.coordinator(for: item.route, modelContext: modelContext)
                        .environment(\.modelContext, modelContext)
                }
        }
        .sheet(item: $coordinator.sheetItem) { item in
            coordinator.coordinator(for: item.route, modelContext: modelContext)
                .environment(\.modelContext, modelContext)
        }
        .fullScreenCover(item: $coordinator.fullScreenItem) { item in
            coordinator.coordinator(for: item.route, modelContext: modelContext)
                .environment(\.modelContext, modelContext)
        }
        .task {
            coordinator.start()
        }
    }
}

#Preview {
    RootView()
}
