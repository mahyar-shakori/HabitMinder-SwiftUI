//
//  SetNameView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct SetNameView: View {
    @ObservedObject private var setNameViewModel: SetNameViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @FocusState private var isFocused: Bool
    @State private var tempUserName = ""
    
    init(setNameViewModel: SetNameViewModel) {
        self.setNameViewModel = setNameViewModel
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
        .onAppear {
            tempUserName = setNameViewModel.uiState.userName
        }
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
        TextField(
            LocalizedStrings.SetNamePage.userNamePlaceholder,
            text: $tempUserName
        )
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
        .onChange(of: tempUserName) { _, newValue in
            setNameViewModel.setUserName(newValue)
        }
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
        CustomButton(style: CustomButtonStylePreset.tertiary(
            backgroundColor: setNameViewModel.uiState.isValid ? themeManager.appPrimary : themeManager.appSecondary
        )) {
            setNameViewModel.validateAndContinue {
                setNameViewModel.goToWelcomePage()
            }
        } label: {
            Text(LocalizedStrings.SetNamePage.continueButton)
        }
    }
  
    private var borderColor: Color {
        setNameViewModel.uiState.borderState == .error ? .red : themeManager.appPrimary
    }
    
    private var borderWidth: CGFloat {
        setNameViewModel.uiState.borderState == .error ? 2 : 1
    }
}

#Preview {
    let fakeCoordinator = SetNameCoordinator(navigate: { _ in
    })
    let themeManager = ThemeManager()
    let userDefaultsContainer = DIContainer.UserDefaults()
    let viewModel = SetNameViewModel(
        coordinator: fakeCoordinator,
        userNameStorage: userDefaultsContainer.userNameStorage,
        loginStorage: userDefaultsContainer.loginStorage
    )
    SetNameView(setNameViewModel: viewModel)
        .environmentObject(themeManager)
}
