//
//  SetNameView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct SetNameView: View {
    @StateObject private var setNameViewModel = SetNameViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            headerImage()
            hiText()
            userNameTextField()
            errorText()
            
            Spacer()
            
            continueButton()
        }
        .dismissKeyboard(focus: $isFocused)
        .navigationBarBackButtonHidden(true)
    }
}

private extension SetNameView {
    
    @ViewBuilder
    func headerImage() -> some View {
        Image(.setName)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func hiText() -> some View {
        Text(LocalizedStrings.SetNamePage.hiDialog)
            .font(.AppFont.rooneySansBold.size(21))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 64)
    }
    
    @ViewBuilder
    func userNameTextField() -> some View {
        TextField(LocalizedStrings.SetNamePage.userNamePlaceholder, text: $setNameViewModel.userName)
            .font(.AppFont.rooneySansRegular.size(16))
            .textContentType(.givenName)
            .padding()
            .background(
                Capsule()
                    .stroke(setNameViewModel.borderColor, lineWidth: setNameViewModel.borderSize)
            )
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .focused($isFocused)
            .submitLabel(.done)
    }
    
    @ViewBuilder
    func errorText() -> some View {
        Group {
            if setNameViewModel.errorText.isEmpty {
                Text(" ")
            } else {
                Text(setNameViewModel.errorText)
                    .transition(.opacity)
            }
        }
        .font(.AppFont.rooneySansRegular.size(16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.red)
        .padding(.horizontal, 32)
        .padding(.top, 8)
        .animation(.easeInOut, value: setNameViewModel.errorText)
    }
    
    @ViewBuilder
    func continueButton() -> some View {
        Button(LocalizedStrings.SetNamePage.continueButton) {
            setNameViewModel.validateAndContinue {
                coordinator.push(.welcome)
            }
        }
        .font(.AppFont.rooneySansBold.size(20))
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding(16)
        .background(Capsule().fill(setNameViewModel.buttonColor))
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
    }
}

#Preview {
    SetNameView()
}
