//
//  HomeRouter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI
import SwiftData

struct HomeRouter {
    @ViewBuilder
    func view(
        for route: HomeRoute,
        using coordinator: MainCoordinator,
        modelContext: ModelContext
    ) -> some View {
        switch route {
        case .home(let quote):
            homeScreen(
                mainCoordinator: coordinator,
                modelContext: modelContext,
                quote: quote
            )
        case .addHabit:
            addHabitScreen(
                mainCoordinator: coordinator,
                modelContext: modelContext
            )
        case .editHabit(let habit):
            editHabitScreen(
                mainCoordinator: coordinator,
                modelContext: modelContext,
                habit: habit
            )
        case .futureHabit:
            futureHabitScreen(
                mainCoordinator: coordinator,
                modelContext: modelContext
            )
        case .settingPage:
            settingScreen(
                mainCoordinator: coordinator,
                modelContext: modelContext
            )
        }
    }
    
    @ViewBuilder
    private func homeScreen(
        mainCoordinator: MainCoordinator,
        modelContext: ModelContext,
        quote: String
    ) -> some View {
        let viewCoordinator = HomeCoordinator(navigate: mainCoordinator.navigate)
        let viewModel = HomeViewModel(
            quote: quote,
            habitManager: DataManager<HabitModel>(context: modelContext),
            futureHabitManager: DataManager<FutureHabitModel>(context: modelContext),
            coordinator: viewCoordinator
        )
        HomeView(homeViewModel: viewModel)
    }
    
    @ViewBuilder
    private func addHabitScreen(
        mainCoordinator: MainCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = AddHabitCoordinator(dismiss: mainCoordinator.pop)
        let viewModel = AddHabitViewModel(
            habitManager: DataManager<HabitModel>(context: modelContext),
            coordinator: viewCoordinator
        )
        AddHabitView(addHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func editHabitScreen(
        mainCoordinator: MainCoordinator,
        modelContext: ModelContext,
        habit: HabitModel
    ) -> some View {
        let viewCoordinator = EditHabitCoordinator(dismiss: mainCoordinator.pop)
        let viewModel = EditHabitViewModel(
            dataManager: DataManager<HabitModel>(context: modelContext),
            coordinator: viewCoordinator,
            habit: habit
        )
        EditHabitView(editHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func futureHabitScreen(
        mainCoordinator: MainCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = FutureHabitCoordinator(dismiss: mainCoordinator.pop)
        let viewModel = FutureHabitViewModel(
            habitManager: DataManager<FutureHabitModel>(context: modelContext),
            coordinator: viewCoordinator
        )
        FutureHabitView(futureHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func settingScreen(
        mainCoordinator: MainCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = SettingCoordinator(dismiss: mainCoordinator.pop)
        let viewModel = SettingViewModel(coordinator: viewCoordinator)
        SettingView(settingViewModel: viewModel)
    }
}
