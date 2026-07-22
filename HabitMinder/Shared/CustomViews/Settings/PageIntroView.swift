//
//  PageIntroView.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct PageIntroView<Accessory: View>: View {
    let title: String
    let description: String
    var topPadding: CGFloat = Spacing.xSmall
    @ViewBuilder var accessory: () -> Accessory

    init(
        title: String,
        description: String,
        topPadding: CGFloat = Spacing.xSmall,
        @ViewBuilder accessory: @escaping () -> Accessory
    ) {
        self.title = title
        self.description = description
        self.topPadding = topPadding
        self.accessory = accessory
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            HStack(spacing: Spacing.medium) {
                Text(title)
                    .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                    .foregroundStyle(.primary)

                accessory()
            }

            Text(description)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, topPadding)
    }
}

extension PageIntroView where Accessory == EmptyView {
    init(
        title: String,
        description: String,
        topPadding: CGFloat = Spacing.xSmall
    ) {
        self.init(
            title: title,
            description: description,
            topPadding: topPadding,
            accessory: EmptyView.init
        )
    }
}
