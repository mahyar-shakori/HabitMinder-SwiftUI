//
//  EditHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import SwiftUI

struct EditHabitView: View {
    @ObservedObject private var editHabitViewModel: EditHabitViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    
    init(editHabitViewModel: EditHabitViewModel) {
        self.editHabitViewModel = editHabitViewModel
    }
    
    var body: some View {
        VStack {
            topViews
            addHabitTextField
            Spacer()
            
            if editHabitViewModel.uiState.showToast {
                toastLabel
            }
            
            missHabitButton
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
        .onAppear() {
            tempHabitTitle = editHabitViewModel.uiState.habitTitle
        }
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.EditHabitPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            isDisabled: editHabitViewModel.uiState.isSaveButtonEnabled.not
        )) {
            editHabitViewModel.saveAndDismiss()
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
        }
    }
    
    private var topViews: some View {
        HStack {
            titleText
            Spacer()
            saveButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
    
    private var addHabitTextField: some View {
        TextField(
            LocalizedStrings.Shared.habitPlaceholder,
            text: $tempHabitTitle
        )
        .font(.AppFont.rooneySansRegular.size(16))
        .padding()
        .background(.appWhite)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .focused($isFocused)
        .submitLabel(.done)
        .onChange(of: tempHabitTitle) { _, newValue in
            editHabitViewModel.setHabitTitle(newValue)
        }
    }
    
    private var toastLabel: some View {
        Text(LocalizedStrings.EditHabitPage.missHabitToast)
            .font(.AppFont.rooneySansBold.size(16))
            .foregroundColor(.appWhite)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.primary.opacity(0.8))
            .cornerRadius(12)
            .transition(.opacity.combined(with: .scale))
            .padding(.bottom, 100)
    }
   
    private var missHabitButton: some View {
        CustomButton(style: CustomButtonStylePreset.tertiary(
            backgroundColor: editHabitViewModel.uiState.showToast ? themeManager.appSecondary : themeManager.appPrimary
        )) {
            withAnimation {
                editHabitViewModel.missHabitAndShowToast()
            }
        } label: {
            Text(LocalizedStrings.EditHabitPage.missHabitButton)
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    let sampleHabit = HabitModel(title: "Read book")
    let fakeCoordinator = EditHabitCoordinator(dismiss: {
    })
    let databaseContainer = DIContainer.Database(context: context)
    let themeManager = ThemeManager()
    let viewModel = EditHabitViewModel(
        habitDataManager: databaseContainer.habitDataManager,
        coordinator: fakeCoordinator,
        habit: sampleHabit
    )
    EditHabitView(editHabitViewModel: viewModel)
        .environmentObject(themeManager)
}
