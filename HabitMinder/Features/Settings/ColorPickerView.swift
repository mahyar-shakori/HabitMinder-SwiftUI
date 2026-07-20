//
//  ColorPickerView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct ColorPickerView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding private var isPresented: Bool
    @State private var selectedColor: Color
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self._selectedColor = State(initialValue: .blue)
    }
    
    var body: some View {
        content
            .onAppear {
                selectedColor = themeManager.appPrimary
            }
    }
    
    private var content: some View {
        NavigationView {
            VStack {
                colorPickerView
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolbarTitle
                }
                ToolbarItem(placement: .confirmationAction) {
                    toolbarSaveButton
                }
                ToolbarItem(placement: .cancellationAction) {
                    toolbarCancelButton
                }
            }
        }
    }
    
    private var colorPickerView: some View {
        ZStack {
            Color.appGray
                .ignoresSafeArea()

            VStack(spacing: Spacing.xLarge) {
                colorPickerField
                defaultColorButton
                Spacer()
            }
            .padding()
        }
    }
    
    private var colorPickerField: some View {
        ColorPicker(selection: $selectedColor, supportsOpacity: false) {
            Text(L10n.SettingPage.pickColor)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
        }
        .padding(Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(.appWhite)
        )
    }
    
    private var defaultColorButton: some View {
        AppButton(
            L10n.SettingPage.defaultColor,
            variant: .plain
        ) {
            let defaultColor = Color.appPrimary
            selectedColor = defaultColor
            themeManager.appPrimary = defaultColor
        }
        .padding(Spacing.medium)
        .frame(maxWidth: .infinity)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }
    
    private var toolbarTitle: some View {
        Text(L10n.SettingPage.chooseColor)
            .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
    }
    
    private var toolbarSaveButton: some View {
        ToolbarTextButton(L10n.Shared.saveButton, weight: .bold) {
            themeManager.appPrimary = selectedColor
            isPresented = false
        }
    }
   
    private var toolbarCancelButton: some View {
        ToolbarTextButton(L10n.Shared.cancelButton) {
            isPresented = false
        }
    }
}


#Preview {
    let dependencies = AppDependencies()
    let isPresented = Binding<Bool>.constant(false)
    ColorPickerView(isPresented: isPresented)
        .environmentObject(dependencies.themeManager)
}
