//
//  DropDownItem..swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation

struct DropDownItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: DropDownIcon?
    let target: HomeNavigationTarget
}
