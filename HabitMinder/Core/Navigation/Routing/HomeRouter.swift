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
        let dataManager = DataManager(context: modelContext)
        let userDefaultsStorage = UserDefaultsStorage()

        switch route {
        case .home(let quote):
            return homeScreen(
                coordinator: coordinator,
                dataManager: dataManager,
                userDefaultsStorage: userDefaultsStorage,
                quote: quote,
                connectivityService: WatchConnectivityService(),
            )
        case .addHabit:
            return addHabitScreen(
                coordinator: coordinator,
                dataManager: dataManager,
            )
        case .editHabit(let habit):
            return editHabitScreen(
                coordinator: coordinator,
                dataManager: dataManager,
                habit: habit
            )
        case .futureHabit:
            return futureHabitScreen(
                coordinator: coordinator,
                dataManager: dataManager
            )
        case .settingPage:
            return settingScreen(
                coordinator: coordinator,
                userDefaultsStorage: userDefaultsStorage
            )
        }
    }
    
    private func homeScreen(
        coordinator: any MainCoordinating,
        dataManager: DataManaging,
        userDefaultsStorage: UserDefaultsStoring,
        quote: String,
        connectivityService: WatchConnectivityProviding
    ) -> some View {
        let viewCoordinator = HomeCoordinator(navigate: coordinator.navigate)
        let viewModel = HomeViewModel(
            quote: quote,
            dataManager: dataManager,
            coordinator: viewCoordinator,
            connectivityService: connectivityService,
            userDefaultsStorage: userDefaultsStorage
        )
        return HomeView(homeViewModel: viewModel)
    }
    
    private func addHabitScreen(
        coordinator: any MainCoordinating,
        dataManager: DataManaging
    ) -> some View {
        let viewCoordinator = AddHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = AddHabitViewModel(
            dataManager: dataManager,
            coordinator: viewCoordinator
        )
        return AddHabitView(addHabitViewModel: viewModel)
    }
    
    private func editHabitScreen(
        coordinator: any MainCoordinating,
        dataManager: DataManaging,
        habit: HabitModel
    ) -> some View {
        let viewCoordinator = EditHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = EditHabitViewModel(
            dataManager: dataManager,
            coordinator: viewCoordinator,
            habit: habit
        )
        return EditHabitView(editHabitViewModel: viewModel)
    }
    
    private func futureHabitScreen(
        coordinator: any MainCoordinating,
        dataManager: DataManaging
    ) -> some View {
        let viewCoordinator = FutureHabitCoordinator(dismiss: coordinator.pop)
        let viewModel = FutureHabitViewModel(
            dataManager: dataManager,
            coordinator: viewCoordinator
        )
        return FutureHabitView(futureHabitViewModel: viewModel)
    }
    
    private func settingScreen(
        coordinator: any MainCoordinating,
        userDefaultsStorage: UserDefaultsStoring
    ) -> some View {
        let viewCoordinator = SettingCoordinator(dismiss: coordinator.pop)
        let viewModel = SettingViewModel(
            coordinator: viewCoordinator,
            userDefaultsStorage: userDefaultsStorage
        )
        return SettingView(settingViewModel: viewModel)
    }
}
