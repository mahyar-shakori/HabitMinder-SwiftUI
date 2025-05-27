//
//  NavigationItem.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 26/05/2025.
//

import Foundation

struct NavigationItem: Hashable, Identifiable {
    let id = UUID()
    let route: AppRoute
    let style: PresentationStyle
}
