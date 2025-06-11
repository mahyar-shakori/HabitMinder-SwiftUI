//
//  ThemeManaging.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 09/06/2025.
//

import SwiftUI

protocol ThemeManaging: ObservableObject {
    var appPrimary: Color { get set }
    var appSecondary: Color { get }
}
