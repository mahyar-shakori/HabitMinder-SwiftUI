//
//  IntroView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

struct IntroView: View {
    @State private var introViewModel: IntroViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(introViewModel: IntroViewModel) {
        _introViewModel = State(initialValue: introViewModel)
    }
    
    var body: some View {
        VStack(spacing: Spacing.xSmall) {
            Spacer()
            
            image
            titleText
            descriptionText
            
            Spacer()
            
            bottomControls
        }
        .background(.appGray)
        .navigationBarBackButtonHidden(true)
    }
    
    private var image: some View {
        Image(introViewModel.currentState.image)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, Spacing.medium)
    }
    
    private var titleText: some View {
        Text(introViewModel.currentState.title)
            .font(Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.medium)
            .padding(.top, Spacing.xLarge)
    }
    
    private var descriptionText: some View {
        Text(introViewModel.currentState.description)
            .font(Fonts.bodyLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.medium)
    }
    
    private var bottomControls: some View {
        ZStack {
            pageIndicator
            HStack {
                
                if introViewModel.currentState == .first {
                    skipButton
                }
                
                Spacer()
                nextButton
            }
        }
        .padding(.horizontal, Spacing.large)
        .padding(.bottom, Spacing.medium)
    }
    
    private var skipButton: some View {
        AppButton(
            LocalizedStrings.IntroPage.skipButton,
            variant: .secondary
        ) {
            introViewModel.goToSetNamePage()
        }
    }
    
    private var nextButton: some View {
        AppButton(LocalizedStrings.IntroPage.nextButton) {
            introViewModel.nextState()
        }
    }
    
    private var pageIndicator: some View {
        HStack(spacing: Spacing.xSmall) {
            Capsule()
                .fill(themeManager.appPrimary)
                .frame(width: introViewModel.currentState == .second ? Size.xLarge : Size.large, height: Size.small)
                .animation(.easeInOut(duration: Time.short), value: introViewModel.currentState)

            if introViewModel.currentState == .first {
                Capsule()
                    .fill(themeManager.appSecondary)
                    .frame(width: Size.medium, height: Size.small)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    let dependencies = AppDependencies()
    let fakeCoordinator = IntroCoordinator(navigate: { _ in
    })
    let viewModel = IntroViewModel(
        coordinator: fakeCoordinator
    )
    IntroView(introViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
