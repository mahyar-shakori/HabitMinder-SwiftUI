//
//  SignIn.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {
    private let signInViewModel: SignInViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @FocusState private var isFocused: Bool
    @State private var tempUserName = ""

    init(signInViewModel: SignInViewModel) {
        self.signInViewModel = signInViewModel
    }

    var body: some View {
        VStack(spacing: Spacing.none) {
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
            tempUserName = signInViewModel.userName
        }
    }

    private var headerImage: some View {
        Image(.setName)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, Spacing.medium)
    }

    private var hiText: some View {
        Text(L10n.SignInPage.hiDialog)
            .font(.AppFont.rooneySansBold.size(FontSize.x6Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.x2Large)
    }

    private var signInChoiceText: some View {
        Text(L10n.SignInPage.signIn)
            .font(Font.AppFont.rooneySansRegular.size(FontSize.x2Large))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.small)
    }

    private var userNameTextField: some View {
        TextField(
            L10n.SignInPage.userNamePlaceholder,
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
            signInViewModel.setUserName(newValue)
        }
    }

    private var errorText: some View {
        Text(signInViewModel.errorText.isEmpty ? " " : signInViewModel.errorText)
            .font(Font.AppFont.rooneySansRegular.size(FontSize.x2Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.red)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.xSmall)
            .animation(.easeInOut, value: signInViewModel.errorText)
    }

    private var continueButton: some View {
        AppPrimaryButton(
            title: L10n.SignInPage.continueButton,
            isEnabled: signInViewModel.isValid,
            disablesWhenInvalid: false,
            size: .large
        ) {
            isFocused = false
            signInViewModel.validateAndContinue {
                signInViewModel.goToWelcomePage()
            }
        }
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.medium)
    }

    private var signInSeparator: some View {
        HStack(spacing: Spacing.medium) {
            Rectangle()
                .fill(Color.secondary.opacity(Opacity.seprator))
                .frame(height: LineWidth.thin)

            Text(L10n.SignInPage.or)
                .font(Font.AppFont.rooneySansRegular.size(FontSize.large))
                .foregroundStyle(.secondary)

            Rectangle()
                .fill(Color.secondary.opacity(Opacity.seprator))
                .frame(height: LineWidth.thin)
        }
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.medium)
    }

    private var appleSignInButton: some View {
        SignInWithAppleButton(.signIn) { request in
            isFocused = false
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            signInViewModel.handleAppleSignInResult(result) {
                signInViewModel.goToWelcomePage()
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(maxWidth: .infinity)
        .frame(height: Size.x4Large)
        .clipShape(Capsule())
        .padding(.horizontal, Spacing.xLarge)
        .padding(.bottom, Spacing.xLarge)
    }

    private var borderColor: Color {
        signInViewModel.borderState == .error ? .red : themeManager.appPrimary
    }

    private var borderWidth: CGFloat {
        signInViewModel.borderState == .error ? LineWidth.medium : LineWidth.thin
    }
}

#Preview {
    let dependencies = AppDependencies()
    let introDependencies = dependencies.destinationDependencies.intro
    let fakeCoordinator = SetNameCoordinator(navigate: { _ in
    })
    let viewModel = SignInViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: introDependencies.userDefaultsStorage
    )
    SignInView(signInViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
