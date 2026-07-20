//
//  SetNameView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct SetNameView: View {
    private var setNameViewModel: SetNameViewModel
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
            tempUserName = setNameViewModel.userName
        }
    }
    
    private var headerImage: some View {
        Image(.setName)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, Spacing.medium)
    }
    
    private var hiText: some View {
        Text(LocalizedStrings.SetNamePage.hiDialog)
            .font(Fonts.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.x2Large)
    }
    
    private var userNameTextField: some View {
        TextField(
            LocalizedStrings.SetNamePage.userNamePlaceholder,
            text: $tempUserName
        )
        .font(Fonts.body)
        .textContentType(.givenName)
        .padding()
        .background(
            Capsule()
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .padding(.horizontal, Spacing.xLarge)
        .padding(.top, Spacing.medium)
        .focused($isFocused)
        .submitLabel(.done)
        .onChange(of: tempUserName) { _, newValue in
            setNameViewModel.setUserName(newValue)
        }
    }
    
    private var errorText: some View {
        Text(setNameViewModel.errorText.isEmpty ? " " : setNameViewModel.errorText)
            .font(Fonts.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.red)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.xSmall)
            .animation(.easeInOut, value: setNameViewModel.errorText)
    }
    
    private var continueButton: some View {
        CustomButton(style: CustomButtonStylePreset.tertiary(
            backgroundColor: setNameViewModel.isValid ? themeManager.appPrimary : themeManager.appSecondary
        )) {
            setNameViewModel.validateAndContinue {
                setNameViewModel.goToWelcomePage()
            }
        } label: {
            Text(LocalizedStrings.SetNamePage.continueButton)
        }
    }
  
    private var borderColor: Color {
        setNameViewModel.borderState == .error ? .red : themeManager.appPrimary
    }
    
    private var borderWidth: CGFloat {
        setNameViewModel.borderState == .error ? LineWidth.medium : LineWidth.thin
    }
}

#Preview {
    let fakeCoordinator = SetNameCoordinator(navigate: { _ in
    })
    let userDefaults = UserDefaultsStorage()
    let themeManager = ThemeManager()
    let viewModel = SetNameViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: userDefaults
    )
    SetNameView(setNameViewModel: viewModel)
        .environmentObject(themeManager)
}
