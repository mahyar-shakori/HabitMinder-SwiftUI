//
//  FutureHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct FutureHabitView: View {
    @ObservedObject private var futureHabitViewModel: FutureHabitViewModel
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    @State private var showDeleteAlert = false
    
    init(futureHabitViewModel: FutureHabitViewModel) {
        self.futureHabitViewModel = futureHabitViewModel
    }
    
    var body: some View {
        content
            .background(.appGray)
            .dismissKeyboard(focus: $isFocused)
            .onAppear {
                futureHabitViewModel.fetchHabits()
            }
            .onChange(of: futureHabitViewModel.uiState.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .alert(LocalizedStrings.Alert.Habit.deleteTitle,
                   isPresented: $showDeleteAlert) {
                Button(LocalizedStrings.Shared.okButton, role: .destructive) {
                    futureHabitViewModel.performDelete()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                    futureHabitViewModel.cancelDelete()
                }
            } message: {
                Text(LocalizedStrings.Alert.Habit.deleteMessage)
            }
    }
    
    private var content: some View {
        VStack {
            topViews
            addHabitTextField
            habitList
            Spacer()
        }
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.FutureHabitsPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            isDisabled: futureHabitViewModel.uiState.isSaveButtonEnabled.not
        )) {
            futureHabitViewModel.save()
            tempHabitTitle = ""
            isFocused = false 
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
    
    private var habitList: some View {
        List {
            ForEach(futureHabitViewModel.uiState.listItems) { item in
                FutureHabitListRowView(item: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteSwipeButton(for: item.id)
                    }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
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
        .padding(.bottom, 8)
        .focused($isFocused)
        .submitLabel(.done)
        .onChange(of: tempHabitTitle) { _, newValue in
            futureHabitViewModel.setHabitTitle(newValue)
        }
    }
    
    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            futureHabitViewModel.confirmDelete(id: id)
        } label: {
            Image(uiImage: Image.circularIcon(
                diameter: 50,
                iconName: AppIconName.trash,
                circleColor: .red,
                iconColor: .white
            ))
        }
        .tint(.clear)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    let fakeCoordinator = FutureHabitCoordinator(dismiss: {
    })
    let viewModel = FutureHabitViewModel(
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator
    )
    FutureHabitView(futureHabitViewModel: viewModel)
}
