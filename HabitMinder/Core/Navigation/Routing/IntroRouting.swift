//
//  IntroRouting.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import SwiftUI

protocol IntroRouting {
    @ViewBuilder
    func view(for route: IntroRoute, using coordinator: any BaseCoordinator) -> any View
}
