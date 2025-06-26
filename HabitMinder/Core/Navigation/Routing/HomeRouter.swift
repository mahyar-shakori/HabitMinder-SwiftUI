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
        using coordinator: any MainCoordinating,
        modelContext: ModelContext
    ) -> any View {
        let databaseContainer = DIContainer.Database(context: modelContext)
        let userDefaultsContainer = DIContainer.UserDefaults()
        
        switch route {
        case .home(let quote):
            return homeScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer,
                userDefaultsContainer: userDefaultsContainer,
                quote: quote,
                connectivityService: WatchConnectivityService(),
            )
        case .addHabit:
            return addHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer
            )
        case .editHabit(let habit):
            return editHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer,
                habit: habit
            )
        case .futureHabit:
            return futureHabitScreen(
                coordinator: coordinator,
                databaseContainer: databaseContainer
            )
        case .settingPage:
            return settingScreen(
                coordinator: coordinator,
                userDefaultsContainer: userDefaultsContainer
            )
        }
    }
    
    private func homeScreen(
        coordinator: any MainCoordinating,
        databaseContainer: DIContainer.Database,
        userDefaultsContainer: DIContainer.UserDefaults,
        quote: String,
        connectivityService: WatchConnectivityProviding
    ) -> some View {
        let viewCoordinator = HomeCoordinator(navigate: coordinator.navigate)
        let viewModel = HomeViewModel(
            quote: quote,
            habitDataManager: databaseContainer.habitDataManager,
            futureHabitDataManager: databaseContainer.futureHabitDataManager,
            coordinator: viewCoordinator,
            connectivityService: connectivityService,
            loginStorage: userDefaultsContainer.loginStorage
        )
        return HomeView(homeViewModel: viewModel)
    }
    
    private func addHabitScreen(
        coordinator: any MainCoordinating,
        databaseContainer: DIContainer.Database
    ) -> some View {
        let viewCoordinator = AddHabitCoordinator(dismiss: coordinator.pop)
        let habitDataManager = databaseContainer.habitDataManager
        let viewModel = AddHabitViewModel(
            habitDataManager: habitDataManager,
            coordinator: viewCoordinator
        )
        return AddHabitView(addHabitViewModel: viewModel)
    }
    
    private func editHabitScreen(
        coordinator: any MainCoordinating,
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
        return EditHabitView(editHabitViewModel: viewModel)
    }
    
    private func futureHabitScreen(
        coordinator: any MainCoordinating,
        databaseContainer: DIContainer.Database
    ) -> some View {
        let viewCoordinator = FutureHabitCoordinator(dismiss: coordinator.pop)
        let futureHabitDataManager = databaseContainer.futureHabitDataManager
        let viewModel = FutureHabitViewModel(
            futureHabitDataManager: futureHabitDataManager,
            coordinator: viewCoordinator
        )
        return FutureHabitView(futureHabitViewModel: viewModel)
    }
    
    private func settingScreen(
        coordinator: any MainCoordinating,
        userDefaultsContainer: DIContainer.UserDefaults
    ) -> some View {
        let viewCoordinator = SettingCoordinator(dismiss: coordinator.pop)
        let viewModel = SettingViewModel(
            coordinator: viewCoordinator,
            userNameStorage: userDefaultsContainer.userNameStorage
        )
        return SettingView(settingViewModel: viewModel)
    }
}
