//
//  HabitDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI
import SwiftData

struct HabitDestinationView: View {
    let route: HabitRoute
    let dependencies: HabitDestinationDependencies
    let coordinator: MainCoordinator
    let modelContext: ModelContext

    private var dataManager: DataManaging {
        DataManager(context: modelContext)
    }

    var body: some View {
        switch route {
        case .home(let quote, let author):
            let viewCoordinator = HomeCoordinator(navigate: coordinator.navigate)
            let reminderScheduler = dependencies.reminderScheduler
            let viewModel = HomeViewModel(
                quote: quote,
                author: author,
                dataManager: dataManager,
                coordinator: viewCoordinator,
                connectivityService: dependencies.connectivityService,
                userDefaultsStorage: dependencies.userDefaultsStorage,
                reminderScheduler: reminderScheduler
            )
            HomeView(
                homeViewModel: viewModel,
                reminderScheduler: reminderScheduler
            )
        case .history:
            let viewCoordinator = HabitHistoryCoordinator(dismiss: coordinator.pop)
            let viewModel = HabitHistoryViewModel(
                dataManager: dataManager,
                coordinator: viewCoordinator,
                reminderScheduler: dependencies.reminderScheduler
            )
            HabitHistoryView(habitHistoryViewModel: viewModel)
        }
    }
}
