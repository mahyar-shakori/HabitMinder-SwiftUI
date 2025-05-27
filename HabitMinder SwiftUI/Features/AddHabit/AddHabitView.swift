//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject var coordinator: AddHabitViewCoordinator
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            topViews
            addHabitTextField
        
            Spacer()
        }
        .dismissKeyboard(focus: $isFocused)
    }

    private var titleText: some View {
        Text(LocalizedStrings.AddHabitPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        Button(LocalizedStrings.Shared.saveButton) {
            addHabitViewModel.save()
            NotificationCenter.default.post(name: AppNotification.Habit.added, object: nil)
            coordinator.goBack()
        }
            .font(.AppFont.rooneySansBold.size(20))
            .tint(.primary)
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
        TextField(LocalizedStrings.AddHabitPage.habitPlaceholder, text: $addHabitViewModel.habitTitle)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .focused($isFocused)
            .submitLabel(.done)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    AddHabitView(addHabitViewModel: AddHabitViewModel(habitManager: DataManager<HabitModel>(context: context)))
}
