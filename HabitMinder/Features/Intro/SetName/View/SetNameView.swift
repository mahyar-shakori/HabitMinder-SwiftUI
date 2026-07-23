//
//  SetNameView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import AuthenticationServices
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
        VStack(spacing: 0) {
            Spacer()

            headerImage
            hiText
            signInChoiceText
            userNameTextField
            errorText

            Spacer()

            continueButton
            signInSeparator
            appleSignInButton
        }
        .background {
            Color.appGray
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        }
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
        Text(L10n.SetNamePage.hiDialog)
            .font(.AppFont.rooneySansBold.size(FontSize.x6Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.x2Large)
    }

    private var signInChoiceText: some View {
        Text("Enter your name, or sign in with Apple")
            .font(Font.AppFont.rooneySansRegular.size(FontSize.x2Large))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.small)
    }

    private var userNameTextField: some View {
        TextField(
            L10n.SetNamePage.userNamePlaceholder,
            text: $tempUserName
        )
        .font(Font.AppFont.rooneySansRegular.size(FontSize.x2Large))
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
            .font(Font.AppFont.rooneySansRegular.size(FontSize.x2Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.red)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.xSmall)
            .animation(.easeInOut, value: setNameViewModel.errorText)
    }

    private var continueButton: some View {
        AppPrimaryButton(
            title: L10n.SetNamePage.continueButton,
            isEnabled: setNameViewModel.isValid,
            disablesWhenInvalid: false,
            size: .large
        ) {
            isFocused = false
            setNameViewModel.validateAndContinue {
                setNameViewModel.goToWelcomePage()
            }
        }
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.medium)
    }

    private var signInSeparator: some View {
        HStack(spacing: Spacing.medium) {
            Rectangle()
                .fill(Color.secondary.opacity(0.25))
                .frame(height: LineWidth.thin)

            Text("or")
                .font(Font.AppFont.rooneySansRegular.size(FontSize.large))
                .foregroundStyle(.secondary)

            Rectangle()
                .fill(Color.secondary.opacity(0.25))
                .frame(height: LineWidth.thin)
        }
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.medium)
    }

    private var appleSignInButton: some View {
        SignInWithAppleButton(.signIn) { request in
            isFocused = false
            setNameViewModel.handleAppleSignInRequestStarted()
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            setNameViewModel.handleAppleSignInResult(result) {
                setNameViewModel.goToWelcomePage()
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(maxWidth: .infinity, minHeight: Size.x4Large, maxHeight: Size.x4Large)
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.xLarge)
    }

    private var borderColor: Color {
        setNameViewModel.borderState == .error ? .red : themeManager.appPrimary
    }

    private var borderWidth: CGFloat {
        setNameViewModel.borderState == .error ? LineWidth.medium : LineWidth.thin
    }
}

#Preview {
    let dependencies = AppDependencies()
    let introDependencies = dependencies.destinationDependencies.intro
    let fakeCoordinator = SetNameCoordinator(navigate: { _ in
    })
    let viewModel = SetNameViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: introDependencies.userDefaultsStorage
    )
    SetNameView(setNameViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
