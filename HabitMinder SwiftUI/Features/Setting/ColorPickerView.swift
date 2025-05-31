//
//  ColorPickerView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct ColorPickerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isPresented: Bool
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
                colorPicker
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
    
    private var colorPicker: some View {
        ZStack {
            Color.appGray
                .ignoresSafeArea()
            
            VStack {
                ColorPicker(selection: $selectedColor, supportsOpacity: false) {
                    Text(LocalizedStrings.SettingPage.pickColor)
                        .font(.AppFont.rooneySansRegular.size(18))
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appWhite)
                )
                Spacer()
            }
            .padding()
        }
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.chooseColor)
            .font(.AppFont.rooneySansBold.size(18))
    }
    
    private var toolbarSaveButton: some View {
        Button {
            themeManager.appPrimary = selectedColor
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
                .font(.AppFont.rooneySansBold.size(18))
        }
    }
    
    private var toolbarCancelButton: some View {
        Button {
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.cancelButton)
                .font(.AppFont.rooneySansRegular.size(18))
        }
    }
}

#Preview {
    ColorPickerView(isPresented: .constant(false))
        .environmentObject(ThemeManager.shared)
    
}
