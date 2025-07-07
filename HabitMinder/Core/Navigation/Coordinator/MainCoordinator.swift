//
//  MainCoordinator.swift.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI
import SwiftData

final class MainCoordinator: ObservableObject {
    @Published var path: [NavigationItem] = []
    
    private let introRouting: IntroRouting
    private let mainRouting: MainRouting
    private let userDefaultsStorage: UserDefaultsStoring
    
    init(
        introRouting: IntroRouting,
        mainRouting: MainRouting,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.introRouting = introRouting
        self.mainRouting = mainRouting
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func coordinator(
        for route: AppRoute,
        modelContext: ModelContext
    ) -> some View {
        switch route {
        case .intro(let introRoute):
            introRouting
                .view(
                    for: introRoute,
                    using: self
                )
                .eraseToAnyView()
        case .main(let mainRoute):
            mainRouting
                .view(
                    for: mainRoute,
                    using: self,
                    modelContext: modelContext
                )
                .eraseToAnyView()
        }
    }
}

extension MainCoordinator: MainCoordinating {
    func navigate(to route: AppRoute) {
        let item = NavigationItem(route: route)
        path.append(item)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        guard let first = path.first else {
            return
        }
        path = [first]
    }
    
    func start() {
        let isLoggedIn = userDefaultsStorage.fetch(for: UserDefaultKeys.isLogin) ?? false
        let initialRoute: AppRoute = isLoggedIn ? .intro(.welcome) : .intro(.onboarding)
        path = [NavigationItem(route: initialRoute)]
    }
}
