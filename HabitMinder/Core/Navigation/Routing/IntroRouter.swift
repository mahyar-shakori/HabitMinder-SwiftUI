//
//  IntroRouter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI

struct IntroRouter: IntroRouting {
    func view(
        for route: IntroRoute,
        using coordinator: any MainCoordinating,
    ) -> any View {
        let userDefaultsContainer = DIContainer.UserDefaults()
        
        switch route {
        case .intro:
            return introScreen(coordinator: coordinator)
        case .setName:
            return setNameScreen(
                coordinator: coordinator,
                userDefaultsContainer: userDefaultsContainer
            )
        case .welcome:
            return welcomeScreen(
                coordinator: coordinator,
                userDefaultsContainer: userDefaultsContainer
            )
        }
    }
    
    private func introScreen(
        coordinator: any MainCoordinating
    ) -> some View {
        let viewCoordinator = IntroCoordinator(navigate: coordinator.navigate)
        let viewModel = IntroViewModel(coordinator: viewCoordinator)
        return IntroView(introViewModel: viewModel)
    }
    
    private func setNameScreen(
        coordinator: any MainCoordinating,
        userDefaultsContainer: DIContainer.UserDefaults
    ) -> some View {
        let viewCoordinator = SetNameCoordinator(navigate: coordinator.navigate)
        let viewModel = SetNameViewModel(
            coordinator: viewCoordinator,
            userNameStorage: userDefaultsContainer.userNameStorage,
            loginStorage: userDefaultsContainer.loginStorage
        )
        return SetNameView(setNameViewModel: viewModel)
    }
    
    private func welcomeScreen(
        coordinator: any MainCoordinating,
        userDefaultsContainer: DIContainer.UserDefaults
    ) -> some View {
        let viewCoordinator = WelcomeCoordinator(navigate: coordinator.navigate)
        let viewModel = WelcomeViewModel(
            coordinator: viewCoordinator,
            userNameStorage: userDefaultsContainer.userNameStorage
        )
        return WelcomeView(welcomeViewModel: viewModel)
    }
}
