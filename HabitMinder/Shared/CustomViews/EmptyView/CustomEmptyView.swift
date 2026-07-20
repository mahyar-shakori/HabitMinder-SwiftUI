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
        imageSize: CGFloat = Metrics.defaultImageSize
    ) {
        self.image = image
        self.text = text
        self.imageSize = imageSize
    }
    
    var body: some View {
        VStack(spacing: Metrics.spacing) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            
            Text(text)
                .font(.AppFont.rooneySansRegular.size(Metrics.textFontSize))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, Metrics.horizontalPadding)
        }
        .padding()
    }
}

private enum Metrics {
    static let defaultImageSize: CGFloat = 180
    static let spacing: CGFloat = 10
    static let textFontSize: CGFloat = 17
    static let horizontalPadding: CGFloat = 48
}

#Preview {
    let image = Image(.emptyView)
    let text = LocalizedStrings.HomePage.listSubtitle
    CustomEmptyView(image: image, text: text)
}
