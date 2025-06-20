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
        using coordinator: any BaseCoordinator,
    ) -> any View {
        switch route {
        case .setLanguage:
            setLanguageScreen(coordinator: coordinator)
        case .intro:
            introScreen(coordinator: coordinator)
        case .setName:
            setNameScreen(coordinator: coordinator)
        case .welcome:
            welcomeScreen(coordinator: coordinator)
        }
    }
    
    @ViewBuilder
    private func setLanguageScreen(
        coordinator: any BaseCoordinator
    ) -> some View {
        let viewCoordinator = SetLanguageCoordinator(navigate: coordinator.navigate)
        let viewModel = SetLanguageViewModel(
            coordinator: viewCoordinator,
            languageManager: LanguageManager.shared
        )
        SetLanguageView(setLanguageViewModel: viewModel)
    }
    
    @ViewBuilder
    private func introScreen(
        coordinator: any BaseCoordinator
    ) -> some View {
        let viewCoordinator = IntroCoordinator(navigate: coordinator.navigate)
        let viewModel = IntroViewModel(coordinator: viewCoordinator)
        IntroView(introViewModel: viewModel)
    }
    
    @ViewBuilder
    private func setNameScreen(
        coordinator: any BaseCoordinator
    ) -> some View {
        let viewCoordinator = SetNameCoordinator(navigate: coordinator.navigate)
        let viewModel = SetNameViewModel(
            coordinator: viewCoordinator,
            userNameStorage: DIContainer.UserDefaults.userNameStorage,
            loginStorage: DIContainer.UserDefaults.loginStorage
        )
        SetNameView(setNameViewModel: viewModel)
    }
    
    @ViewBuilder
    private func welcomeScreen(
        coordinator: any BaseCoordinator
    ) -> some View {
        let viewCoordinator = WelcomeCoordinator(navigate: coordinator.navigate)
        let viewModel = WelcomeViewModel(
            coordinator: viewCoordinator,
            userNameStorage: DIContainer.UserDefaults.userNameStorage
)
        WelcomeView(welcomeViewModel: viewModel)
    }
}
