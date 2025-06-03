//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var coordinator: HomeViewCoordinator
    @State private var showDeleteAlert = false
    @State private var showLogoutAlert = false
    
    init(homeViewModel: HomeViewModel) {
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $homeViewModel.isDropDownPresented) {
                dropDownSheet
            }
            .onChange(of: homeViewModel.uiState.navigationTarget) {
                handleNavigation(homeViewModel.uiState.navigationTarget)
            }
            .onChange(of: homeViewModel.uiState.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .onReceive(
                NotificationCenter.default.publisher(for: AppNotification.Habit.added)
                    .merge(with: NotificationCenter.default.publisher(for: AppNotification.Habit.edited))
                    .merge(with: NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
            ) { _ in
                homeViewModel.fetchHabits()
            }
            .alert(LocalizedStrings.Alert.Habit.deleteTitle,
                   isPresented: $showDeleteAlert) {
                Button(LocalizedStrings.Shared.yesButton, role: .destructive) {
                    homeViewModel.performDelete()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                    homeViewModel.cancelDelete()
                }
            } message: {
                Text(LocalizedStrings.Alert.Habit.deleteMessage)
            }
            .alert(LocalizedStrings.Alert.Logout.title,
                   isPresented: $showLogoutAlert) {
                Button(LocalizedStrings.Shared.yesButton, role: .destructive) {
                    homeViewModel.performLogout()
                    coordinator.goToSetLanguage()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                }
            } message: {
                Text(LocalizedStrings.Alert.Logout.message)
            }
    }
    
    private var content: some View {
        VStack {
            topViews
            quoteText
            habitSection
            
            Spacer()
        }
        .background(.appGray)
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.HomePage.title)
            .font(.AppFont.rooneySansBold.size(28))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dropDownButton: some View {
        Button {
            homeViewModel.startDropDownPresenting()
        } label: {
            Image(.dropDownButton)
                .tint(.primary)
        }
    }
    
    private var doneButton: some View {
        Button {
            homeViewModel.stopEditingList()
        } label: {
            Text(LocalizedStrings.HomePage.doneButton)
                .font(.AppFont.rooneySansBold.size(20))
                .tint(.primary)
        }
    }
    
    private var topViews: some View {
        HStack {
            titleText
            Spacer()
            editingControl
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var editingControl: some View {
        if homeViewModel.uiState.isEditingList {
            doneButton
        } else {
            dropDownButton
        }
    }
    
    private var quoteText: some View {
        Text(homeViewModel.quote)
            .font(.AppFont.rooneySansRegular.size(17))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 16)
    }
    
    private var habitSection: some View {
        habitContentView
    }

    @ViewBuilder
    private var habitContentView: some View {
        if homeViewModel.uiState.listItems.isEmpty {
            VStack {
                Spacer()
                CustomEmptyView(
                    image: Image(.emptyView),
                    text: LocalizedStrings.HomePage.emptyView
                )
                Spacer()
            }
        } else {
            habitList
        }
    }
    
    private var dropDownSheet: some View {
        let items = homeViewModel.dropDownItems
        let rowHeight: CGFloat = 65
        
        return DropDownSheetView(items: items) { selectedIndex in
            homeViewModel.handleDropDownSelection(index: selectedIndex)
        }
        .presentationDetents([.height(rowHeight * CGFloat(items.count))])
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    private var habitList: some View {
        List {
            ForEach(homeViewModel.uiState.listItems) { item in
                HabitListRowView(item: item)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteSwipeButton(for: item.id)
                        editSwipeButton(for: item.id)
                    }
            }
            .onMove(perform: homeViewModel.moveItem)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(homeViewModel.uiState.isEditingList ? .active : .inactive))
        .refreshable { await homeViewModel.refresh() }
    }
    
    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.confirmDelete(id: id)
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
    
    private func editSwipeButton(for id: UUID) -> some View {
        Button {
            guard let habit = homeViewModel.confirmEdit(id: id) else {
                return
            }
            coordinator.goToEditHabit(habit: habit)
        } label: {
            Image(uiImage: Image.circularIcon(
                diameter: 50,
                iconName: AppIconName.pencil,
                circleColor: .blue,
                iconColor: .white
            ))
        }
        .tint(.clear)
    }
    
    private func handleNavigation(_ target: HomeNavigationTarget?) {
        guard let target = target else {
            return
        }
        switch target {
        case .addHabit:
            coordinator.goToAddHabit()
        case .futureHabit:
            coordinator.goToFutureHabit()
        case .editHabitList:
            if homeViewModel.uiState.listItems.isNotEmpty {
                homeViewModel.handleEditHabitList()
            }
        case .setting:
            coordinator.goToSetting()
        case .logout:
            showLogoutAlert = true
        }
        homeViewModel.setNavigationTargetEmpty()
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    HomeView(
        homeViewModel: HomeViewModel(
            quote: "Test Quote",
            habitManager: DataManager<HabitModel>(
                context: context
            ), futureHabitManager: DataManager<FutureHabitModel>(
                context: context
            )
        )
    )
}
