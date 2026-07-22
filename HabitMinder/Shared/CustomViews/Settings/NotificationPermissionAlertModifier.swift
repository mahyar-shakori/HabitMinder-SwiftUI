//
//  NotificationPermissionAlertModifier.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct NotificationPermissionAlertModifier: ViewModifier {
    let isPresented: Binding<Bool>
    let opensAppSettings: Bool
    let message: String
    let onDismiss: () -> Void
    let onOpenAppSettings: () -> Void

    func body(content: Content) -> some View {
        content.alert(
            L10n.AddHabitPage.notificationAlertTitle,
            isPresented: isPresented
        ) {
            if opensAppSettings {
                Button(L10n.AddHabitPage.notificationSettingsButton) {
                    onDismiss()
                    onOpenAppSettings()
                }

                Button(L10n.Shared.cancelButton, role: .cancel) {
                    onDismiss()
                }
            } else {
                Button(L10n.Shared.okButton) {
                    onDismiss()
                }
            }
        } message: {
            Text(message)
        }
    }
}

extension View {
    func notificationPermissionAlert(
        isPresented: Binding<Bool>,
        opensAppSettings: Bool,
        message: String,
        onDismiss: @escaping () -> Void,
        onOpenAppSettings: @escaping () -> Void
    ) -> some View {
        modifier(NotificationPermissionAlertModifier(
            isPresented: isPresented,
            opensAppSettings: opensAppSettings,
            message: message,
            onDismiss: onDismiss,
            onOpenAppSettings: onOpenAppSettings
        ))
    }
}
