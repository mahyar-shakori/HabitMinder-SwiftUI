//
//  IntroRouter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI

struct IntroRouter {
    @ViewBuilder
    func view(
        for route: IntroRoute,
        using coordinator: MainCoordinator,
    ) -> some View {
        switch route {
        case .setLanguage:
            setLanguageScreen(mainCoordinator: coordinator)
        case .intro:
            introScreen(mainCoordinator: coordinator)
        case .setName:
            setNameScreen(mainCoordinator: coordinator)
        case .welcome:
            welcomeScreen(mainCoordinator: coordinator)
        }
    }
    
    @ViewBuilder
    private func setLanguageScreen(
        mainCoordinator: MainCoordinator
    ) -> some View {
        let viewCoordinator = SetLanguageCoordinator(navigate: mainCoordinator.navigate)
        let viewModel = SetLanguageViewModel(
            coordinator: viewCoordinator,
            languageManager: LanguageManager.shared
        )
        SetLanguageView(setLanguageViewModel: viewModel)
    }
    
    @ViewBuilder
    private func introScreen(
        mainCoordinator: MainCoordinator
    ) -> some View {
        let viewCoordinator = IntroCoordinator(navigate: mainCoordinator.navigate)
        let viewModel = IntroViewModel(coordinator: viewCoordinator)
        IntroView(introViewModel: viewModel)
    }
    
    @ViewBuilder
    private func setNameScreen(
        mainCoordinator: MainCoordinator
    ) -> some View {
        let viewCoordinator = SetNameCoordinator(navigate: mainCoordinator.navigate)
        let viewModel = SetNameViewModel(coordinator: viewCoordinator)
        SetNameView(setNameViewModel: viewModel)
    }
    
    @ViewBuilder
    private func welcomeScreen(
        mainCoordinator: MainCoordinator
    ) -> some View {
        let viewCoordinator = WelcomeCoordinator(navigate: mainCoordinator.navigate)
        let viewModel = WelcomeViewModel(coordinator: viewCoordinator)
        WelcomeView(welcomeViewModel: viewModel)
    }
}
