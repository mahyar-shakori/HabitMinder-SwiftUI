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

            VStack(spacing: Metrics.contentSpacing) {
                colorPickerField
                defaultColorButton
                Spacer()
            }
            .padding()
        }
    }
    
    private var colorPickerField: some View {
        ColorPicker(selection: $selectedColor, supportsOpacity: false) {
            Text(LocalizedStrings.SettingPage.pickColor)
                .font(.AppFont.rooneySansRegular.size(Metrics.textFontSize))
        }
        .padding(Metrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardCornerRadius)
                .fill(.appWhite)
        )
    }
    
    private var defaultColorButton: some View {
        AppButton(
            LocalizedStrings.SettingPage.defaultColor,
            variant: .plain
        ) {
            let defaultColor = Color.appPrimary
            selectedColor = defaultColor
            themeManager.appPrimary = defaultColor
        }
        .padding(Metrics.cardPadding)
        .frame(maxWidth: .infinity)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.cardCornerRadius))
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.chooseColor)
            .font(.AppFont.rooneySansBold.size(Metrics.textFontSize))
    }
    
    private var toolbarSaveButton: some View {
        ToolbarTextButton(LocalizedStrings.Shared.saveButton, weight: .bold) {
            themeManager.appPrimary = selectedColor
            isPresented = false
        }
    }
   
    private var toolbarCancelButton: some View {
        ToolbarTextButton(LocalizedStrings.Shared.cancelButton) {
            isPresented = false
        }
    }
}

private enum Metrics {
    static let contentSpacing: CGFloat = 16
    static let cardPadding: CGFloat = 12
    static let cardCornerRadius: CGFloat = 12
    static let textFontSize: CGFloat = 18
}

#Preview {
    let dependencies = AppDependencies()
    let isPresented = Binding<Bool>.constant(false)
    ColorPickerView(isPresented: isPresented)
        .environmentObject(dependencies.themeManager)
}
