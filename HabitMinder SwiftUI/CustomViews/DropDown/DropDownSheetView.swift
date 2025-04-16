//
//  DropDownSheetView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct DropDownSheetView: View {
    let items: [DropDownItem]
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    onSelect(index)
                } label: {
                    DropDownRowView(item: item)
                }
                if index != items.count - 1 {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
    }
}
