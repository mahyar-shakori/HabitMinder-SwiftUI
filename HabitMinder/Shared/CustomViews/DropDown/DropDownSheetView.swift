//
//  DropDownSheetView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct DropDownSheetView: View {
    private let items: [DropDownItem]
    private let onSelect: (Int) -> Void
    
    init(
        items: [DropDownItem],
        onSelect: @escaping (Int) -> Void
    ) {
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                
                Button {
                    if item.isEnabled {
                        onSelect(index)
                    }
                } label: {
                    VStack(spacing: 0) {
                        DropDownRowView(item: item, isEnabled: item.isEnabled)
                        
                        if index < items.count - 1 {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .disabled(item.isEnabled.not)
            }
        }
    }
}

#Preview {
    let items = [
        DropDownItem(
            title: "Add Habit",
            imageName: .addNewHabit,
            target: .addHabit,
            isEnabled: true
        ),
        DropDownItem(
            title: "Future Habit",
            imageName: .futureHabit,
            target: .futureHabit,
            isEnabled: false
        )
    ]
    let onSelect: (Int) -> Void = { _ in }
    DropDownSheetView(
        items: items,
        onSelect: onSelect
    )
}
