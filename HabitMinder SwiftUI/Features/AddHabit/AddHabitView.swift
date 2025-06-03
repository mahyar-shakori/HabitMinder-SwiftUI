//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject private var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject private var coordinator: AddHabitViewCoordinator
    @FocusState private var isFocused: Bool
    
    init(addHabitViewModel: AddHabitViewModel) {
        _addHabitViewModel = StateObject(wrappedValue: addHabitViewModel)
    }

    var body: some View {
        content
            .background(.appGray)
            .dismissKeyboard(focus: $isFocused)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        coordinator.goBack()
                    } label: {
                        HStack {
                            Image(systemName:                         AppIconName.chevronLeft)
                            Text(LocalizedStrings.Shared.backButton)
                        }
                    }
                }
            }
    }
    
    private var content: some View {
        VStack {
            topViews
            addHabitTextField
        
            Spacer()
        }
    }

    private var titleText: some View {
        Text(LocalizedStrings.AddHabitPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        Button {
            addHabitViewModel.save()
            addHabitViewModel.postHabitAddedNotification()
            coordinator.goBack()
        } label: {
                Text(LocalizedStrings.Shared.saveButton)
                    .font(.AppFont.rooneySansBold.size(20))
                    .tint(.primary)
        }
        .disabled(addHabitViewModel.isSaveButtonEnabled.not)
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
        TextField(LocalizedStrings.Shared.habitPlaceholder, text: $addHabitViewModel.habitTitle)
            .font(.AppFont.rooneySansRegular.size(16))
            .padding()
            .background(.appWhite)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .focused($isFocused)
            .submitLabel(.done)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    AddHabitView(addHabitViewModel: AddHabitViewModel(habitManager: DataManager<HabitModel>(context: context)))
}
