//
//  MainCoordinator.swift.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import SwiftUI
import SwiftData

final class MainCoordinator: BaseCoordinator {
    @Published var path: [NavigationItem] = []
    @Published var sheetItem: NavigationItem?
    @Published var fullScreenItem: NavigationItem?
    
    private let introRouting: IntroRouting
    private let homeRouting: HomeRouting
    
    init(introRouting: IntroRouting, homeRouting: HomeRouting) {
        self.introRouting = introRouting
        self.homeRouting = homeRouting
    }
    
    func navigate(
        to route: AppRoute,
        style: PresentationStyle
    ) {
        let item = NavigationItem(
            route: route,
            style: style
        )
        switch style {
        case .push:
            path.append(item)
        case .sheet:
            sheetItem = item
        case .fullScreenCover:
            fullScreenItem = item
        }
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
        let loginStorage = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
        let initialRoute: AppRoute = loginStorage.fetch() == true ? .intro(.welcome) : .intro(.setLanguage)
        path = [NavigationItem(
            route: initialRoute,
            style: .push
        )]
    }
    
    @ViewBuilder
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
        case .home(let homeRoute):
            homeRouting
                .view(
                    for: homeRoute,
                    using: self,
                    modelContext: modelContext
                )
                .eraseToAnyView()
        }
    }
}
