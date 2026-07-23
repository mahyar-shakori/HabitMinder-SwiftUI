//
//  IntroDestinationView.swift
//  HabitMinder
//
//  Created by Mahyar on 20/07/2026.
//

import SwiftUI

struct IntroDestinationView: View {
    let route: IntroRoute
    let dependencies: IntroDestinationDependencies
    let coordinator: MainCoordinator

    var body: some View {
        switch route {
        case .onboarding:
            let viewCoordinator = IntroCoordinator(navigate: coordinator.navigate)
            let viewModel = IntroViewModel(coordinator: viewCoordinator)
            IntroView(introViewModel: viewModel)
        case .setName:
            let viewCoordinator = SetNameCoordinator(navigate: coordinator.navigate)
            let viewModel = SignInViewModel(
                coordinator: viewCoordinator,
                userDefaultsStorage: dependencies.userDefaultsStorage
            )
            SignInView(signInViewModel: viewModel)
        case .welcome:
            let viewCoordinator = WelcomeCoordinator(navigate: coordinator.navigate)
            let viewModel = WelcomeViewModel(
                coordinator: viewCoordinator,
                repository: dependencies.quoteRepository,
                userDefaultsStorage: dependencies.userDefaultsStorage
            )
            WelcomeView(welcomeViewModel: viewModel)
        }
    }
}
