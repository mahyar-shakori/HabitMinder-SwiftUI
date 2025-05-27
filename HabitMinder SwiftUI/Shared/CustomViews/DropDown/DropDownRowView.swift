//
//  DropDownRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct DropDownRowView: View {
    let item: DropDownItem
    
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
            }
        }
    }
    
    private var text: some View {
        Text(item.title)
            .font(.AppFont.rooneySansRegular.size(17))
            .foregroundColor(.primary)
    }
}
