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
        let databaseContainer = DIContainer.Database(context: modelContext)

        switch route {
        case .home(let quote):
            homeScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer,
                quote: quote
            )
        case .addHabit:
            addHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer
            )
        case .editHabit(let habit):
            editHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer,
                habit: habit
            )
        case .futureHabit:
            futureHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer
            )
        case .settingPage:
            settingScreen(coordinator: coordinator)
        }
    }
    
    @ViewBuilder
    private func homeScreen(
        coordinator: any BaseCoordinator,
        databaseContainer: DIContainer.Database,
        quote: String
    ) -> some View {
        let viewCoordinator = HomeCoordinator(navigate: coordinator.navigate)
        let connectivityService = WatchConnectivityService()
        let viewModel = HomeViewModel(
            quote: quote,
            habitDataManager: databaseContainer.habitDataManager,
            futureHabitDataManager: databaseContainer.futureHabitDataManager,
            coordinator: viewCoordinator,
            connectivityService: connectivityService,
            loginStorage: DIContainer.UserDefaults.loginStorage
        )
        HomeView(homeViewModel: viewModel)
    }
    
    @ViewBuilder
    private func addHabitScreen(
        coordinator: any BaseCoordinator,
        databaseContainer: DIContainer.Database
    ) -> some View {
        let viewCoordinator = AddHabitCoordinator(dismiss: coordinator.pop)
        let habitDataManager = databaseContainer.habitDataManager
        let viewModel = AddHabitViewModel(
            habitDataManager: habitDataManager,
            coordinator: viewCoordinator
        )
        AddHabitView(addHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func editHabitScreen(
        coordinator: any BaseCoordinator,
        databaseContainer: DIContainer.Database,
        habit: HabitModel
    ) -> some View {
        let viewCoordinator = EditHabitCoordinator(dismiss: coordinator.pop)
        let habitDataManager = databaseContainer.habitDataManager
        let viewModel = EditHabitViewModel(
            habitDataManager: habitDataManager,
            coordinator: viewCoordinator,
            habit: habit
        )
        EditHabitView(editHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func futureHabitScreen(
        coordinator: any BaseCoordinator,
        databaseContainer: DIContainer.Database
    ) -> some View {
        let viewCoordinator = FutureHabitCoordinator(dismiss: coordinator.pop)
        let futureHabitDataManager = databaseContainer.futureHabitDataManager
        let viewModel = FutureHabitViewModel(
            futureHabitDataManager: futureHabitDataManager,
            coordinator: viewCoordinator
        )
        FutureHabitView(futureHabitViewModel: viewModel)
    }
    
    @ViewBuilder
    private func settingScreen(
        coordinator: any BaseCoordinator,
    ) -> some View {
        let viewCoordinator = SettingCoordinator(dismiss: coordinator.pop)
        let viewModel = SettingViewModel(
            coordinator: viewCoordinator,
            userNameStorage: DIContainer.UserDefaults.userNameStorage
        )
        SettingView(settingViewModel: viewModel)
    }
}
