//
//  Coordinator.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import Foundation

final class Coordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
}
