//
//  IntroView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

struct IntroView: View {
    private var introViewModel: IntroViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(introViewModel: IntroViewModel) {
        self.introViewModel = introViewModel
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
            .padding(.horizontal, Spacing.xLarge)
    }
    
    private var titleText: some View {
        Text(introViewModel.currentState.title)
            .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
            .padding(.top, Spacing.x7Large)
    }
    
    private var descriptionText: some View {
        Text(introViewModel.currentState.description)
            .font(Font.AppFont.rooneySansRegular.size(FontSize.x4Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.xLarge)
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
        .padding(.horizontal, Spacing.x5Large)
        .padding(.bottom, Spacing.xLarge)
    }
    
    private var skipButton: some View {
        AppButton(
            L10n.IntroPage.skipButton,
            variant: .secondary
        ) {
            introViewModel.goToSetNamePage()
        }
    }
    
    private var nextButton: some View {
        AppButton(
            L10n.IntroPage.nextButton,
            variant: .onboardingNext
        ) {
            introViewModel.nextState()
        }
        .padding(.horizontal, Spacing.xSmall)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: Spacing.small) {
            Capsule()
                .fill(themeManager.appPrimary)
                .frame(width: introViewModel.currentState == .second ? Size.x6Large : Size.x2Large, height: Size.xSmall)
                .animation(.easeInOut(duration: Time.short), value: introViewModel.currentState)

            if introViewModel.currentState == .first {
                Capsule()
                    .fill(themeManager.appSecondary)
                    .frame(width: Size.small, height: Size.xSmall)
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
