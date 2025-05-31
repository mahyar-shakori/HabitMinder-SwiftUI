//
//  CustomEmptyView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct CustomEmptyView: View {
    let image: Image
    let text: String
    
    var body: some View {
        VStack(spacing: 10) {
            image
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Text(text)
                .font(.AppFont.rooneySansRegular.size(17))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 48)
        }
        .padding()
    }
}

#Preview {
    CustomEmptyView(
        image: Image(.emptyView),
        text: "Test")
}
