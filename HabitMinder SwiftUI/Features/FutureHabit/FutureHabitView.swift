//
//  FutureHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct FutureHabitView: View {
    @StateObject private var futureHabitViewModel: FutureHabitViewModel
    @EnvironmentObject private var coordinator: FutureHabitViewCoordinator
    @FocusState private var isFocused: Bool
    @State private var showDeleteAlert = false
    
    init(futureHabitViewModel: FutureHabitViewModel) {
        _futureHabitViewModel = StateObject(wrappedValue: futureHabitViewModel)
    }
    
    var body: some View {
        content
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
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.FutureHabitsPage.title)
            .font(.AppFont.rooneySansBold.size(28))
    }
    
    private var saveButton: some View {
        Button {
            futureHabitViewModel.save()
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
                .font(.AppFont.rooneySansBold.size(20))
                .tint(.primary)
        }
        .disabled(futureHabitViewModel.uiState.isSaveButtonEnabled.not)
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
        TextField(LocalizedStrings.Shared.habitPlaceholder, text: $futureHabitViewModel.habitTitle)
            .font(.AppFont.rooneySansRegular.size(16))
            .padding()
            .background(.appWhite)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .focused($isFocused)
            .submitLabel(.done)
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
    
    FutureHabitView(futureHabitViewModel: FutureHabitViewModel(habitManager: DataManager<FutureHabitModel>(context: context)))
}
