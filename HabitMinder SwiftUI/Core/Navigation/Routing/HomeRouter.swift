//
//  HomeRouter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI
import SwiftData

struct HomeRouter: HomeRouting {
    func view(
        for route: HomeRoute,
        using coordinator: any BaseCoordinator,
        modelContext: ModelContext
    ) -> any View {
        switch route {
        case .home(let quote):
            homeScreen(
                coordinator: coordinator,
                modelContext: modelContext,
                quote: quote
            )
        case .addHabit:
            addHabitScreen(
                coordinator: coordinator,
                modelContext: modelContext
            )
        case .editHabit(let habit):
            editHabitScreen(
                coordinator: coordinator,
                modelContext: modelContext,
                habit: habit
            )
        case .futureHabit:
            futureHabitScreen(
                coordinator: coordinator,
                modelContext: modelContext
            )
        case .settingPage:
            settingScreen(
                coordinator: coordinator,
                modelContext: modelContext
            )
        }
    }
    
    @ViewBuilder
    private func homeScreen(
        coordinator: any BaseCoordinator,
        modelContext: ModelContext,
        quote: String
    ) -> some View {
        let viewCoordinator = HomeCoordinator(navigate: coordinator.navigate)
        let connectivityService = WatchConnectivityService()
        let viewModel = HomeViewModel(
            quote: quote,
            habitManager: DataManager<HabitModel>(context: modelContext),
            futureHabitManager: DataManager<FutureHabitModel>(context: modelContext),
            coordinator: viewCoordinator,
            connectivityService: connectivityService
        )
        HomeView(homeViewModel: viewModel)
    }
    
    @ViewBuilder
    private func addHabitScreen(
        coordinator: any BaseCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = AddHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = AddHabitViewModel(
            habitManager: DataManager<HabitModel>(context: modelContext),
            coordinator: viewCoordinator
        )
        AddHabitView(addHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func editHabitScreen(
        coordinator: any BaseCoordinator,
        modelContext: ModelContext,
        habit: HabitModel
    ) -> some View {
        let viewCoordinator = EditHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = EditHabitViewModel(
            dataManager: DataManager<HabitModel>(context: modelContext),
            coordinator: viewCoordinator,
            habit: habit
        )
        EditHabitView(editHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func futureHabitScreen(
        coordinator: any BaseCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = FutureHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = FutureHabitViewModel(
            habitManager: DataManager<FutureHabitModel>(context: modelContext),
            coordinator: viewCoordinator
        )
        FutureHabitView(futureHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func settingScreen(
        coordinator: any BaseCoordinator,
        modelContext: ModelContext
    ) -> some View {
        let viewCoordinator = SettingCoordinator(dismiss: coordinator.pop)
        let viewModel = SettingViewModel(coordinator: viewCoordinator)
        SettingView(settingViewModel: viewModel)
    }
}
