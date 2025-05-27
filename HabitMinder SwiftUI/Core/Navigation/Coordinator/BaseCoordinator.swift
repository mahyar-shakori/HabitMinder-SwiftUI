//
//  BaseCoordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

protocol BaseCoordinator: ObservableObject {
    var path: [NavigationItem] { get set }
    func navigate(to route: AppRoute, style: PresentationStyle)
    func pop()
    func popToRoot()
    func start()
}
