//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject var coordinator: Coordinator
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            headerStack
            addHabitTextField
        
            Spacer()
        }
            .navigationBarBackButtonHidden(true)
            .dismissKeyboard(focus: $isFocused)
    }
    
    private var cancelButton: some View {
        Button(LocalizedStrings.Shared.cancelButton) {
            coordinator.pop()
        }
            .font(.AppFont.rooneySansRegular.size(16))
            .tint(Color.accentColor)
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.AddHabitPage.title)
            .font(.AppFont.rooneySansBold.size(17))
    }
    
    private var saveButton: some View {
        Button(LocalizedStrings.Shared.saveButton) {
            addHabitViewModel.save()
            NotificationCenter.default.post(name: .habitAdded, object: nil)

            coordinator.pop()
        }
            .font(.AppFont.rooneySansBold.size(16))
            .tint(addHabitViewModel.saveButtonColor)
            .disabled(!addHabitViewModel.isSaveButtonEnabled)
    }
    
    private var headerStack: some View {
        HStack {
            cancelButton
            
            Spacer()
            titleText
            Spacer()
            
            saveButton
        }
        .padding(.horizontal, 32)
        .padding(.top, 40)
    }
    
    private var addHabitTextField: some View {
        TextField(LocalizedStrings.AddHabitPage.habitPlaceholder, text: $addHabitViewModel.habitTitle)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 48)
            .focused($isFocused)
            .submitLabel(.done)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    AddHabitView(addHabitViewModel: AddHabitViewModel(habitManager: DataManager<Habit>(context: context)))
        .environmentObject(Coordinator())
}
