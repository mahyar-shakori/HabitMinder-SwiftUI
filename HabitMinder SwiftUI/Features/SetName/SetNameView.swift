//
//  SetNameView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct SetNameView: View {
    @StateObject private var setNameViewModel: SetNameViewModel
    @EnvironmentObject private var coordinator: SetNameViewCoordinator
    @FocusState private var isFocused: Bool
    
    init(setNameViewModel: SetNameViewModel) {
        _setNameViewModel = StateObject(wrappedValue: setNameViewModel)
    }
   
    var body: some View {
        VStack {
            Spacer()
            
            headerImage
            hiText
            userNameTextField
            errorText
            
            Spacer()
            
            continueButton
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerImage: some View {
        Image(.setName)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 16)
    }
    
    private var hiText: some View {
        Text(LocalizedStrings.SetNamePage.hiDialog)
            .font(.AppFont.rooneySansBold.size(21))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 64)
    }
    
    private var userNameTextField: some View {
        TextField(LocalizedStrings.SetNamePage.userNamePlaceholder, text: $setNameViewModel.userName)
            .font(.AppFont.rooneySansRegular.size(16))
            .textContentType(.givenName)
            .padding()
            .background(
                Capsule()
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .focused($isFocused)
            .submitLabel(.done)
    }
    
    private var errorText: some View {
        Text(setNameViewModel.uiState.errorText.isEmpty ? " " : setNameViewModel.uiState.errorText)
            .font(.AppFont.rooneySansRegular.size(16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.red)
            .padding(.horizontal, 32)
            .padding(.top, 8)
            .animation(.easeInOut, value: setNameViewModel.uiState.errorText)
    }
    
    private var continueButton: some View {
        Button {
            setNameViewModel.validateAndContinue {
                coordinator.goToWelcome()
            }
        } label: {
            Text(LocalizedStrings.SetNamePage.continueButton)
                .font(.AppFont.rooneySansBold.size(20))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            Capsule().fill(setNameViewModel.uiState.isValid ? ThemeManager.shared.appPrimary : ThemeManager.shared.appSecondary)
        )
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
    }
}

private extension SetNameView {
    var borderColor: Color {
        setNameViewModel.uiState.borderState == .error ? .red : ThemeManager.shared.appPrimary
    }
    
    var borderWidth: CGFloat {
        setNameViewModel.uiState.borderState == .error ? 2 : 1
    }
}

#Preview {
    SetNameView(setNameViewModel: SetNameViewModel())
}
