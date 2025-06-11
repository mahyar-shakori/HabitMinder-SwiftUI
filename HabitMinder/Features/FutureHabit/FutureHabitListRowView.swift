//
//  FutureHabitListRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct FutureHabitListRowView: View {
    let item: FutureHabitItem
    
    var body: some View {
        HStack {
            Text(item.title)
            .font(.AppFont.rooneySansBold.size(18))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.dateCreate.formatted(date: .abbreviated, time: .omitted))
            .font(.AppFont.rooneySansRegular.size(14))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(8)
    }
}

#Preview {
    let id = UUID()
    let date = Date()
    let item = FutureHabitItem(
        id: id,
        title: "Drink Water",
        dateCreate: date
    )
    FutureHabitListRowView(item: item)
}
