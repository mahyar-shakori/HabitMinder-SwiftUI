//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    @State private var showDeleteAlert = false
    @State private var showLogoutAlert = false
    @State private var isDropDownPresented = false
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isDropDownPresented) {
                dropDownSheet
            }
            .onChange(of: homeViewModel.uiState.navigationTarget) {_, newTarget in
                homeViewModel.handleNavigation(newTarget)
            }
            .onChange(of: homeViewModel.uiState.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .onChange(of: homeViewModel.uiState.performLogoutAlert) { _, newValue in
                showLogoutAlert = newValue
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
                    homeViewModel.resetLogoutAlert()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                    homeViewModel.resetLogoutAlert()
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
    
    @ViewBuilder
    private var editingButtonLabel: some View {
        if homeViewModel.uiState.isEditingList {
            Text(LocalizedStrings.HomePage.doneButton)
                .font(.AppFont.rooneySansBold.size(20))
        } else {
            Image(.dropDownButton)
        }
    }
    
    private var editingControl: some View {
        CustomButton(style: CustomButtonStylePreset.default()
        ) {
            if homeViewModel.uiState.isEditingList {
                homeViewModel.stopEditingList()
            } else {
                isDropDownPresented = true
            }
        } label: {
            editingButtonLabel
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
    
    private var quoteText: some View {
        Text(homeViewModel.displayedQuote)
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
            homeViewModel.editHabit(id: id)
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
    
    private var dropDownSheet: some View {
        let items = homeViewModel.uiState.dropDownItems
        let rowHeight: CGFloat = 65
        
        return DropDownSheetView(items: items) { selectedIndex in
            homeViewModel.handleDropDownSelection(index: selectedIndex)
            isDropDownPresented = false
        }
        .presentationDetents([.height(rowHeight * CGFloat(items.count))])
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    
    let fakeCoordinator = HomeCoordinator(navigate: { _ in
    })
    let connectivityService = WatchConnectivityService()
    let userDefaults = UserDefaultsStorage()
    let viewModel = HomeViewModel(
        quote: "Test Quote",
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        connectivityService: connectivityService,
        userDefaultsStorage: userDefaults
    )
    HomeView(homeViewModel: viewModel)
}
