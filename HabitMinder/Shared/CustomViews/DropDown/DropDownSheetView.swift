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
    private let onHeightChange: (CGFloat) -> Void

    init(
        items: [DropDownItem],
        onSelect: @escaping (Int) -> Void,
        onHeightChange: @escaping (CGFloat) -> Void
    ) {
        self.items = items
        self.onSelect = onSelect
        self.onHeightChange = onHeightChange
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    if item.isEnabled { onSelect(index) }
                } label: {
                    VStack(spacing: 0) {
                        DropDownRowView(item: item, isEnabled: item.isEnabled)

                            Divider()
                                .frame(height: 1)
                                .padding(.leading, 16)
                    }
                }
                .disabled(item.isEnabled.not)
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewHeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(ViewHeightKey.self) { h in
            onHeightChange(h)
        }
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
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
    let onHeightChange: (CGFloat) -> Void = { _ in }
    DropDownSheetView(
        items: items,
        onSelect: onSelect,
        onHeightChange: onHeightChange
    )
}
