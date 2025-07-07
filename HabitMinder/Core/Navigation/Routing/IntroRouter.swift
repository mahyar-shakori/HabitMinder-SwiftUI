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
        let userDefaultsStorage = DIContainer.shared.resolveOptional(fallback: UserDefaultsStorage())

        switch route {
        case .onboarding:
            return introScreen(coordinator: coordinator)
        case .setName:
            return setNameScreen(
                coordinator: coordinator,
                userDefaultsStorage: userDefaultsStorage
            )
        case .welcome:
            return welcomeScreen(
                coordinator: coordinator,
                userDefaultsStorage: userDefaultsStorage
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
        userDefaultsStorage: UserDefaultsStoring
    ) -> some View {
        let viewCoordinator = SetNameCoordinator(navigate: coordinator.navigate)
        let viewModel = SetNameViewModel(
            coordinator: viewCoordinator,
            userDefaultsStorage: userDefaultsStorage
        )
        return SetNameView(setNameViewModel: viewModel)
    }
    
    private func welcomeScreen(
        coordinator: any MainCoordinating,
        userDefaultsStorage: UserDefaultsStoring
    ) -> some View {
        let viewCoordinator = WelcomeCoordinator(navigate: coordinator.navigate)
       
        let apiFetching = DIContainer.shared.resolveOptional(
            scope: .feature(.welcome),
            fallback: APIService()
        )

        let viewModel = WelcomeViewModel(
            coordinator: viewCoordinator,
            apiFetching: apiFetching,
            userDefaultsStorage: userDefaultsStorage
        )
        return WelcomeView(welcomeViewModel: viewModel)
    }
}
