//
//  MainTabView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftData
import SwiftUI

struct MainTabView: View {
    private let quote: String
    private let author: String
    private let dependencies: MainDestinationDependencies
    private let coordinator: MainCoordinator
    private let modelContext: ModelContext

    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab = MainTab.habits
    @State private var homeViewModel: HomeViewModel?
    @State private var habitHistoryViewModel: HabitHistoryViewModel?
    @State private var settingsViewModel: SettingsViewModel?

    init(
        quote: String,
        author: String,
        dependencies: MainDestinationDependencies,
        coordinator: MainCoordinator,
        modelContext: ModelContext
    ) {
        self.quote = quote
        self.author = author
        self.dependencies = dependencies
        self.coordinator = coordinator
        self.modelContext = modelContext
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            habitsTab
                .tabItem {
                    Label(L10n.HomePage.tabHabits, systemImage: SystemIconName.calendar)
                }
                .tag(MainTab.habits)

            historyTab
                .tabItem {
                    Label(L10n.HomePage.tabHistory, systemImage: SystemIconName.wandAndStars)
                }
                .tag(MainTab.history)

            settingsTab
                .tabItem {
                    Label(L10n.HomePage.tabSettings, systemImage: SystemIconName.gearshape)
                }
                .tag(MainTab.settings)
        }
        .tint(themeManager.appPrimary)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            prepareTabViewModelsIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: AppNotification.Habit.futureAdded)) { _ in
            homeViewModel?.fetchHabits()
            habitHistoryViewModel?.fetchHabits()
            selectedTab = .history
        }
        .onReceive(NotificationCenter.default.publisher(for: AppNotification.Habit.futureStarted)) { _ in
            homeViewModel?.fetchHabits()
            selectedTab = .habits
        }
    }

    private var habitsTab: some View {
        Group {
            if let homeViewModel {
                HomeView(
                    homeViewModel: homeViewModel,
                    navigateToProfileSettings: navigateToProfileSettings
                )
                .environmentObject(themeManager)
            }
        }
    }

    private var historyTab: some View {
        Group {
            if let habitHistoryViewModel {
                HabitHistoryView(
                    habitHistoryViewModel: habitHistoryViewModel,
                    navigateToProfileSettings: navigateToProfileSettings
                )
                .environmentObject(themeManager)
            }
        }
    }

    private var settingsTab: some View {
        Group {
            if let settingsViewModel {
                SettingsView(settingsViewModel: settingsViewModel)
                    .environmentObject(themeManager)
            }
        }
    }

    private func prepareTabViewModelsIfNeeded() {
        guard homeViewModel == nil || habitHistoryViewModel == nil || settingsViewModel == nil else {
            return
        }

        let dataManager = DataManager(context: modelContext)

        if homeViewModel == nil {
            let homeCoordinator = HomeCoordinator(navigate: coordinator.navigate)
            homeViewModel = HomeViewModel(
                quote: quote,
                author: author,
                dataManager: dataManager,
                coordinator: homeCoordinator,
                connectivityService: dependencies.habits.connectivityService,
                userDefaultsStorage: dependencies.habits.userDefaultsStorage,
                reminderScheduler: dependencies.habits.reminderScheduler
            )
        }

        if habitHistoryViewModel == nil {
            let habitHistoryCoordinator = HabitHistoryCoordinator {
                selectedTab = .habits
            }
            habitHistoryViewModel = HabitHistoryViewModel(
                dataManager: dataManager,
                coordinator: habitHistoryCoordinator,
                reminderScheduler: dependencies.habits.reminderScheduler
            )
        }

        if settingsViewModel == nil {
            let settingCoordinator = SettingsCoordinator(
                dismiss: { selectedTab = .habits },
                navigateToSettingsRoute: { coordinator.navigate(to: .main(.settings($0))) },
                resetToSetName: { coordinator.reset(to: .intro(.setName)) }
            )
            let logoutUseCase = LogoutUseCase(
                dataManager: dataManager,
                reminderScheduler: dependencies.settings.reminderScheduler,
                userDefaultsStorage: dependencies.settings.userDefaultsStorage,
                themeManager: dependencies.settings.themeManager,
                profileImageStorage: dependencies.settings.profileImageStorage
            )
            settingsViewModel = SettingsViewModel(
                coordinator: settingCoordinator,
                userDefaultsStorage: dependencies.settings.userDefaultsStorage,
                profileImageStorage: dependencies.settings.profileImageStorage,
                logoutUseCase: logoutUseCase
            )
        }
    }

    private func navigateToProfileSettings() {
        coordinator.navigate(to: .main(.settings(.profile)))
    }
}

private enum MainTab {
    case habits
    case history
    case settings
}
