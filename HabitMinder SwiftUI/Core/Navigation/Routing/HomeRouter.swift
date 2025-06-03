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
    func view(for route: HomeRoute, using coordinator: MainCoordinator, modelContext: ModelContext) -> some View {
        switch route {
        case .home(let quote):
            let viewCoordinator = HomeViewCoordinator(navigate: coordinator.navigate)
            HomeView(
                homeViewModel: HomeViewModel(
                    quote: quote,
                    habitManager: DataManager<HabitModel>(context: modelContext), futureHabitManager: DataManager<FutureHabitModel>(context: modelContext)
                )
            )
            .environmentObject(viewCoordinator)
            .environmentObject(ThemeManager.shared)
            
        case .addHabit:
            let viewCoordinator = AddHabitViewCoordinator(dismiss: coordinator.pop)
            AddHabitView(
                addHabitViewModel: AddHabitViewModel(
                    habitManager: DataManager<HabitModel>(context: modelContext)
                )
            ).environmentObject(viewCoordinator)
        case .editHabit(let habit):
            let viewCoordinator = EditHabitViewCoordinator(dismiss: coordinator.pop)
            EditHabitView(
                editHabitViewModel: EditHabitViewModel(habit: habit,
                dataManager: DataManager<HabitModel>(context: modelContext))
            )
            .environmentObject(viewCoordinator)
        case .futureHabit:
            let viewCoordinator = FutureHabitViewCoordinator(dismiss: coordinator.pop)
            FutureHabitView(
                futureHabitViewModel: FutureHabitViewModel(
                    habitManager: DataManager<FutureHabitModel>(context: modelContext)
                )
            ).environmentObject(viewCoordinator)
        case .settingPage:
            let viewCoordinator = SettingViewCoordinator(dismiss: coordinator.pop)
            SettingView(settingViewModel: SettingViewModel())
                .environmentObject(LanguageManager.shared)
                .environmentObject(ThemeManager.shared)
                .environmentObject(viewCoordinator)
        }
    }
}
