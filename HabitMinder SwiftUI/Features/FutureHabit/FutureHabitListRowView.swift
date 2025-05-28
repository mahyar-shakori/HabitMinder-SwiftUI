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
