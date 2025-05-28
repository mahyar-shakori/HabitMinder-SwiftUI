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
                    if item.isEnabled {
                        onSelect(index)
                    }
                } label: {
                    DropDownRowView(item: item, isEnabled: item.isEnabled)
                }
                .disabled(item.isEnabled.not)
                
                Divider()
                    .padding(.leading, 16)
            }
        }
    }
}
