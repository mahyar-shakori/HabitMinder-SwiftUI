//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $homeViewModel.isDropDownPresented) {
                dropDownSheet
            }
            .onChange(of: homeViewModel.navigationTarget) {
                handleNavigation(homeViewModel.navigationTarget)
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .habitAdded)
                    .merge(with: NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
            ) { _ in
                homeViewModel.fetchHabits()
            }
            .alert(LocalizedStrings.Alert.Habit.deleteTitle,
                   isPresented: $homeViewModel.showDeleteAlert) {
                Button(LocalizedStrings.Shared.okButton, role: .destructive) {
                    homeViewModel.performDelete()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                    homeViewModel.showDeleteAlert = false
                }
            } message: {
                Text(LocalizedStrings.Alert.Habit.deleteMessage)
            }
            .alert(LocalizedStrings.Alert.Habit.editTitle,
                   isPresented: $homeViewModel.showEditAlert) {
                Button(LocalizedStrings.Shared.okButton) {
                    homeViewModel.performEdit()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) { }
            } message: {
                Text(LocalizedStrings.Alert.Habit.deleteMessage)
            }
    }
    
    private var content: some View {
        VStack {
            topViews
            quoteText
            habitSection
            
            Spacer()
        }
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.HomePage.title)
            .font(.AppFont.rooneySansBold.size(28))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dropDownButton: some View {
        Button(action: {
            homeViewModel.isDropDownPresented = true
        }) {
            Image(.dropDownButton)
                .tint(.primary)
        }
    }
    
    private var doneButton: some View {
        Button(LocalizedStrings.HomePage.doneButton) {
            homeViewModel.isEditingList = false
        }
        .font(.AppFont.rooneySansBold.size(20))
        .tint(.primary)
    }
    
    private var topViews: some View {
        HStack {
            titleText
            Spacer()
            if homeViewModel.isEditingList {
                doneButton
            } else {
                dropDownButton
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
    
    private var quoteText: some View {
        Text(homeViewModel.quote)
            .font(.AppFont.rooneySansRegular.size(17))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 16)
    }
    
    private var habitSection: some View {
        Group {
            if homeViewModel.listItems.isEmpty {
                Spacer()
                CustomEmptyView(
                    image: Image(.emptyView),
                    text: LocalizedStrings.HomePage.emptyView
                )
                Spacer()
            } else {
                habitList
            }
        }
    }
    
    private var dropDownSheet: some View {
        DropDownSheetView(items: homeViewModel.dropDownItems) { selectedIndex in
            homeViewModel.handleDropDownSelection(index: selectedIndex)
        }
        .presentationDetents([.height(CGFloat(60 * homeViewModel.dropDownItems.count))])
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    private var habitList: some View {
        List {
            ForEach(homeViewModel.listItems) { item in
                HabitListRowView(item: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteSwipeButton(for: item.id)
                        editSwipeButton(for: item.id)
                    }
            }
            .onMove(perform: homeViewModel.moveItem)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(homeViewModel.isEditingList ? .active : .inactive))
        .refreshable { await homeViewModel.refresh() }
    }
    
    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.confirmDelete(id: id)
        } label: {
            Image(uiImage: Image.circularIcon(
                diameter: 50,
                iconName: Image.trashIcon,
                circleColor: .red,
                iconColor: .white
            ))
        }
        .tint(.clear)
    }
    
    private func editSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.confirmEdit(id: id)
        } label: {
            Image(uiImage: Image.circularIcon(
                diameter: 50,
                iconName: Image.pencilIcon,
                circleColor: .blue,
                iconColor: .white
            ))
        }
        .tint(.clear)
    }
    
    private func handleNavigation(_ target: HomeNavigationTarget?) {
        guard let target = target else { return }
        
        switch target {
        case .addHabit:
            coordinator.push(.addHabit)
        case .editHabitList:
            homeViewModel.handleEditHabitList()
        case .rename:
            coordinator.push(.setName)
        }
        homeViewModel.navigationTarget = nil
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    HomeView(homeViewModel: HomeViewModel(quote: "Test Quote", habitManager: DataManager<Habit>(context: context)))
        .environmentObject(Coordinator())
}
