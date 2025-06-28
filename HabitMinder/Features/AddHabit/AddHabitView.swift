//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject private var addHabitViewModel: AddHabitViewModel
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    
    init(addHabitViewModel: AddHabitViewModel) {
        self.addHabitViewModel = addHabitViewModel
    }
    
    var body: some View {
        VStack {
            topViews
            addHabitTextField
            Spacer()
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.AddHabitPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            isDisabled: addHabitViewModel.uiState.isSaveButtonEnabled.not
        )) {
            addHabitViewModel.saveAndDismiss()
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
            addHabitViewModel.setHabitTitle(newValue)
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    let fakeCoordinator = AddHabitCoordinator(dismiss: {
    })
    let databaseContainer = DIContainer.Database(context: context)
    let themeManager = ThemeManager()
    let viewModel = AddHabitViewModel(
        habitDataManager: databaseContainer.habitDataManager,
        coordinator: fakeCoordinator
    )
    AddHabitView(addHabitViewModel: viewModel)
        .environmentObject(themeManager)
}
