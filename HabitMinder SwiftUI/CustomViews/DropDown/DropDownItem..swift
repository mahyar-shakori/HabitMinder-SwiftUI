//
//  DropDownItem..swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct DropDownItem: Identifiable {
    let id = UUID()
    let title: String
    let image: Image?
    let target: HomeNavigationTarget
}
