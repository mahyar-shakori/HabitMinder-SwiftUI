//
//  IntroView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/03/2025.
//

import SwiftUI

struct IntroView: View {
    @StateObject private var introViewModel = IntroViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
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
        Image(introViewModel.currentImage)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 16)
    }
    
    private var titleText: some View {
        Text(introViewModel.currentTitleText)
            .font(.AppFont.rooneySansBold.size(24))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 32)
    }
    
    private var descriptionText: some View {
        Text(introViewModel.currentDescriptionText)
            .font(.AppFont.rooneySansRegular.size(18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
    
    private var bottomControls: some View {
        ZStack {
            Image(introViewModel.pageControlDot)
            HStack {
                introViewModel.isSkipHidden ? nil : skipButton
                
                Spacer()
                
                nextButton
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var skipButton: some View {
        Button(LocalizedStrings.IntroPage.skipButton) {
            coordinator.push(.setName)
        }
        .font(.AppFont.rooneySansRegular.size(16))
        .tint(.accent)
        .padding(.horizontal, 8)
        
    }
    
    private var nextButton: some View {
        Button(LocalizedStrings.IntroPage.nextButton) {
            introViewModel.currentState == .first ? introViewModel.nextState() : coordinator.push(.setName)
        }
        .font(.AppFont.rooneySansRegular.size(18))
        .foregroundColor(.white)
        .padding(8)
        .padding(.horizontal, 8)
        .background(Capsule().fill(.accent))
    }
}

#Preview {
    IntroView()
}
