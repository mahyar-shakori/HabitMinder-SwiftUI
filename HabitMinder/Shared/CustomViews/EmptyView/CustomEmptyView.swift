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
    private let imageSize: CGFloat
    
    init(
        image: Image,
        text: String,
        imageSize: CGFloat = Size.largeEmptyImage
    ) {
        self.image = image
        self.text = text
        self.imageSize = imageSize
    }
    
    var body: some View {
        VStack(spacing: Spacing.small) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            
            Text(text)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, Spacing.x8Large)
        }
        .padding()
    }
}


#Preview {
    let image = Image(.emptyView)
    let text = L10n.HomePage.listSubtitle
    CustomEmptyView(image: image, text: text)
}
