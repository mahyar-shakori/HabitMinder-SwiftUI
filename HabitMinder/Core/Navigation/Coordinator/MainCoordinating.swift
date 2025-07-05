//
//  MainCoordinating.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

protocol MainCoordinating {
    var path: [NavigationItem] { get set }
    func navigate(to route: AppRoute)
    func pop()
    func popToRoot()
    func start()
}
