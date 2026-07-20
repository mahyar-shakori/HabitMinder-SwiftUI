//
//  ManageHabitDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI
import SwiftData

struct ManageHabitDestinationView: View {
    let route: ManageHabitRoute
    let dependencies: ManageHabitDestinationDependencies
    let coordinator: MainCoordinator
    let modelContext: ModelContext

    private var dataManager: DataManaging {
        DataManager(context: modelContext)
    }

    var body: some View {
        switch route {
        case .add:
            let viewCoordinator = AddHabitCoordinator(dismiss: coordinator.pop)
            let viewModel = AddHabitViewModel(
                dataManager: dataManager,
                coordinator: viewCoordinator,
                reminderScheduler: dependencies.reminderScheduler
            )
            AddHabitView(addHabitViewModel: viewModel)
        case .edit(let id):
            let viewCoordinator = EditHabitCoordinator(dismiss: coordinator.pop)
            let viewModel = EditHabitViewModel(
                dataManager: dataManager,
                coordinator: viewCoordinator,
                habitID: id,
                reminderScheduler: dependencies.reminderScheduler
            )
            EditHabitView(editHabitViewModel: viewModel)
        }
    }
}
