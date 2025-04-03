//
//  RootView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .intro:
                        IntroView()
                    case .setName:
                        SetNameView()
                    case .welcome:
                        WelcomeView()
                    case .home(let quote):
                        HomeView(quote: quote)
                    }
                }
        }
        .onAppear {
            let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: UserDefaultKeys.isLogin)
            coordinator.path = loginStorage.fetch() == true ? [.welcome] : [.intro]
        }
    }
}
