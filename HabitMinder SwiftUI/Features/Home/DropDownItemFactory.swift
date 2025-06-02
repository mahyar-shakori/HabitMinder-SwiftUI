//
//  DropDownItemFactory.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import Foundation

enum DropDownItemFactory {
    static func makeItems(for uiState: HomeUIState) -> [DropDownItem] {
        return [
            DropDownItem(
                title: LocalizedStrings.Cell.DropDown.addNewHabit,
                imageName: .addNewHabit,
                target: .addHabit,
                isEnabled: true
            ),
            DropDownItem(
                title: LocalizedStrings.Cell.DropDown.futureHabit,
                imageName: .futureHabit,
                target: .futureHabit,
                isEnabled: true
            ),
            DropDownItem(
                title: LocalizedStrings.Cell.DropDown.editHabitList,
                imageName: .editHabitList,
                target: .editHabitList,
                isEnabled: uiState.listItems.isNotEmpty
            ),
            DropDownItem(
                title: LocalizedStrings.Cell.DropDown.setting,
                imageName: .setting,
                target: .setting,
                isEnabled: true
            ),
            DropDownItem(
                title: LocalizedStrings.Cell.DropDown.logout,
                imageName: .logout,
                target: .logout,
                isEnabled: true
            )
        ]
    }
}
