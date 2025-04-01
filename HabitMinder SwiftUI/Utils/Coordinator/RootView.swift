//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            IntroView(introViewModel: IntroViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .intro:
                        IntroView(introViewModel: IntroViewModel())
                    case .setName:
                        SetNameView(setNameViewModel: SetNameViewModel())
                    case .welcome:
                        WelcomeView()
                    }
                }
        }
    }
}
