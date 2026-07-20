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

            VStack(spacing: 16) {
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
                .font(.AppFont.rooneySansRegular.size(18))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.appWhite)
        )
    }
    
    private var defaultColorButton: some View {
        CustomButton(style: CustomButtonStylePreset.tertiary(
            font: .AppFont.rooneySansRegular.size(16),
            tintColor: .blue,
            outerPadding: .insets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)),
            shape: AnyShape(RoundedRectangle(cornerSize: 12.asCGSize))
        )) {
            let defaultColor = Color.appPrimary
            selectedColor = defaultColor
            themeManager.appPrimary = defaultColor
        } label: {
            Text(LocalizedStrings.SettingPage.defaultColor)
        }
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.chooseColor)
            .font(.AppFont.rooneySansBold.size(18))
    }
    
    private var toolbarSaveButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            font: .AppFont.rooneySansBold.size(18),
            tintColor: .blue,
        )) {
            themeManager.appPrimary = selectedColor
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
        }
    }
   
    private var toolbarCancelButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            font: .AppFont.rooneySansRegular.size(18),
            tintColor: .blue,
        )) {
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.cancelButton)
        }
    }
}

#Preview {
    let isPresented = Binding<Bool>.constant(false)
    let themeManager = ThemeManager()
    ColorPickerView(isPresented: isPresented)
        .environmentObject(themeManager)
}
