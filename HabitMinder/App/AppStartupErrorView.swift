//
//  AppStartupErrorView.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import SwiftUI

struct AppStartupErrorView: View {
    let message: String?

    var body: some View {
        VStack(spacing: Spacing.medium) {
            Image(systemName: SystemIconName.exclamationmarkTriangle)
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text(L10n.AppStartup.errorTitle)
                .font(.headline)

            Text(message ?? L10n.AppStartup.errorMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.large)
    }
}

#Preview {
    AppStartupErrorView(message: nil)
}
