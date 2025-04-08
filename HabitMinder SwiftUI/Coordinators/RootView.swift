//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .onAppear(perform: setupInitialRoute)
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .intro:
            IntroView(introViewModel: IntroViewModel())
        case .setName:
            SetNameView(setNameViewModel: SetNameViewModel())
        case .welcome:
            WelcomeView(welcomeViewModel: WelcomeViewModel())
        case .home(let quote):
            HomeView(homeViewModel: HomeViewModel(quote: quote, habitManager: DataManager<Habit>(context: modelContext)))
        case .addHabit:
            AddHabitView(addHabitViewModel: AddHabitViewModel(habitManager: DataManager<Habit>(context: modelContext)))
        }
    }

    private func setupInitialRoute() {
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        coordinator.path = loginStorage.fetch() == true ? [.welcome] : [.intro]
    }
}
