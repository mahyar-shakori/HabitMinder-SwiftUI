//
//  EditHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import SwiftUI

struct EditHabitView: View {
    @StateObject private var editHabitViewModel: EditHabitViewModel
    @EnvironmentObject private var coordinator: EditHabitViewCoordinator
    @FocusState private var isFocused: Bool
    @State private var showToast = false
    
    init(editHabitViewModel: EditHabitViewModel) {
        _editHabitViewModel = StateObject(wrappedValue: editHabitViewModel)
    }
    
    var body: some View {
        VStack {
            topViews
            addHabitTextField
            
            Spacer()
            
            if showToast {
                toastLabel
            }
            
            missHabitButton
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
            
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.EditHabitPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        Button {
            editHabitViewModel.save()
            editHabitViewModel.postHabitEditedNotification()
            coordinator.goBack()
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
                .font(.AppFont.rooneySansBold.size(20))
                .tint(.primary)
        }
        .disabled(editHabitViewModel.isSaveButtonEnabled.not)
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
        TextField(LocalizedStrings.Shared.habitPlaceholder, text: $editHabitViewModel.habitTitle)
            .font(.AppFont.rooneySansRegular.size(16))
            .padding()
            .background(.appWhite)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .focused($isFocused)
            .submitLabel(.done)
    }
    
    private var toastLabel: some View {
        Text(LocalizedStrings.EditHabitPage.missHabitToast)
            .font(.AppFont.rooneySansBold.size(16))
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .transition(.opacity.combined(with: .scale))
            .padding(.bottom, 100)
    }
    
    private var missHabitButton: some View {
        Button {
            withAnimation {
                editHabitViewModel.missHabit()
                editHabitViewModel.postHabitEditedNotification()
                showToast = true
            }
            DispatchQueue.delay(2) {
                withAnimation {
                    showToast = false
                }
            }
        } label: {
            Text(LocalizedStrings.EditHabitPage.missHabitButton)
                .font(.AppFont.rooneySansBold.size(20))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            Capsule().fill(showToast ? ThemeManager.shared.appSecondary : ThemeManager.shared.appPrimary)
        )
        .disabled(showToast)
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    EditHabitView(editHabitViewModel: EditHabitViewModel(habit: HabitModel(title: "Read book"), dataManager: DataManager<HabitModel>(context: context)))
}
