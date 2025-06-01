//
//  IntroView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

struct IntroView: View {
    @StateObject private var introViewModel: IntroViewModel
    @EnvironmentObject private var coordinator: IntroViewCoordinator
    
    init(introViewModel: IntroViewModel) {
        _introViewModel = StateObject(wrappedValue: introViewModel)
    }
    
    var body: some View {
        VStack(spacing: 8) {
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
        Image(introViewModel.pageState.image)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 16)
    }
    
    private var titleText: some View {
        Text(introViewModel.pageState.titleText)
            .font(.AppFont.rooneySansBold.size(24))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 32)
    }
    
    private var descriptionText: some View {
        Text(introViewModel.pageState.descriptionText)
            .font(.AppFont.rooneySansRegular.size(18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
    
    private var bottomControls: some View {
        ZStack {
            pageControl
            HStack {
                if introViewModel.pageState.isSkipHidden.not {
                    skipButton
                }
                Spacer()
                nextButton
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var skipButton: some View {
        Button {
            coordinator.goToSetName()
        } label: {
            Text(LocalizedStrings.IntroPage.skipButton)
                .font(.AppFont.rooneySansRegular.size(16))
                .tint(ThemeManager.shared.appPrimary)
        }
        .padding(.horizontal, 8)
    }
    
    private var nextButton: some View {
        Button {
            introViewModel.currentState == .first ? introViewModel.nextState() : coordinator.goToSetName()
        } label: {
          Text(LocalizedStrings.IntroPage.nextButton)
                .font(.AppFont.rooneySansRegular.size(18))
                .foregroundColor(.white)
        }
        .padding(8)
        .padding(.horizontal, 8)
        .background(
            Capsule().fill(ThemeManager.shared.appPrimary)
        )
    }
    
    private var pageControl: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(ThemeManager.shared.appPrimary)
                .frame(width: introViewModel.currentState == .second ? 70 : 40, height: 10)
                .animation(.easeInOut(duration: 0.3), value: introViewModel.currentState)
            
            if introViewModel.currentState == .first {
                Capsule()
                    .fill(ThemeManager.shared.appSecondary)
                    .frame(width: 20, height: 10)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    IntroView(introViewModel: IntroViewModel())
}
