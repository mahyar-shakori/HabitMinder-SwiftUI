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
        Text(L10n.SetNamePage.hiDialog)
            .font(.AppFont.rooneySansBold.size(FontSize.x6Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.x2Large)
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
        Button {
            setNameViewModel.validateAndContinue {
                setNameViewModel.goToWelcomePage()
            }
        } label: {
            Text(L10n.SetNamePage.continueButton)
                .font(.AppFont.rooneySansBold.size(FontSize.x5Large))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.xLarge)
                .padding(.vertical, Spacing.xLarge)
                .foregroundStyle(.appWhite)
                .background(setNameViewModel.isValid ? themeManager.appPrimary : themeManager.appSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(setNameViewModel.isValid.not)
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
