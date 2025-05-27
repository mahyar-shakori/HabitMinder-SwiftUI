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
        Button(LocalizedStrings.IntroPage.skipButton) {
            coordinator.goToSetName()
        }
        .font(.AppFont.rooneySansRegular.size(16))
        .tint(.accent)
        .padding(.horizontal, 8)
        
    }
    
    private var nextButton: some View {
        Button(LocalizedStrings.IntroPage.nextButton) {
            introViewModel.currentState == .first ? introViewModel.nextState() : coordinator.goToSetName(presentationStyle: .fullScreenCover)
        }
        .font(.AppFont.rooneySansRegular.size(18))
        .foregroundColor(.white)
        .padding(8)
        .padding(.horizontal, 8)
        .background(Capsule().fill(.accent))
    }
    
    private var pageControl: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(.accent)
                .frame(width: introViewModel.currentState == .second ? 70 : 40, height: 10)
                .animation(.easeInOut(duration: 0.3), value: introViewModel.currentState)
            
            if introViewModel.currentState == .first {
                Capsule()
                    .fill(.appSecondary)
                    .frame(width: 20, height: 10)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    IntroView(introViewModel: IntroViewModel())
}
