//
//  IntroRouter.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI

struct IntroRouter {
    @ViewBuilder
    func view(for route: IntroRoute, using coordinator: MainCoordinator) -> some View {
        switch route {
        case .setLanguage:
            let viewCoordinator = SetLanguageViewCoordinator(navigate: coordinator.navigate)
            SetLanguageView().environmentObject(viewCoordinator)
        case .intro:
            let viewCoordinator = IntroViewCoordinator(navigate: coordinator.navigate)
            IntroView(introViewModel: IntroViewModel()).environmentObject(viewCoordinator)
        case .setName:
            let viewCoordinator = SetNameViewCoordinator(navigate: coordinator.navigate)
            SetNameView(setNameViewModel: SetNameViewModel()).environmentObject(viewCoordinator)
        case .welcome:
            let viewCoordinator = WelcomeViewCoordinator(navigate: coordinator.navigate)
            WelcomeView(welcomeViewModel: WelcomeViewModel()).environmentObject(viewCoordinator)
        }
    }
}
