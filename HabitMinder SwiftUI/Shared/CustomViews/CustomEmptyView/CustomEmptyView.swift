//
//  CustomEmptyView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct CustomEmptyView: View {
    private let image: Image
    private let text: String
    
    init(
        image: Image,
        text: String
    ) {
        self.image = image
        self.text = text
    }
    
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
    let image = Image(.emptyView)
    let text = "Test"
    CustomEmptyView(image: image, text: text)
}
