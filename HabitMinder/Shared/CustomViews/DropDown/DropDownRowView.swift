//
//  DropDownRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct DropDownRowView: View {
    private let item: DropDownItem
    private let isEnabled: Bool
    
    init(
        item: DropDownItem,
        isEnabled: Bool = true
    ) {
        self.item = item
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        HStack(spacing: 16) {
            image
            text
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    private var image: some View {
        Group {
            if let name = item.imageName {
                Image(name.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .padding(.leading, 16)
                    .opacity(isEnabled ? 1.0 : 0.4)
            }
        }
    }
    
    private var text: some View {
        Text(item.title)
            .font(.AppFont.rooneySansRegular.size(17))
            .foregroundColor(isEnabled ? .primary : .gray)
    }
}

#Preview {
    let item = DropDownItem(
        title: "Add Habit",
        imageName: .addNewHabit,
        target: .addHabit,
        isEnabled: true
    )
    let isEnabled = true
    DropDownRowView(item: item, isEnabled: isEnabled)
}
