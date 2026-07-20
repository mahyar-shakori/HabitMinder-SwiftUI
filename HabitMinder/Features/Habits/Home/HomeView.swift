//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showDeleteAlert = false
    @State private var showLogoutAlert = false
    @State private var dropDownHeight: CGFloat = 0
    @State private var isDropDownPresented = false
    @State private var selectedTab = HomeTab.habits

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    var body: some View {
        tabContent
            .navigationTitle(LocalizedStrings.HomePage.title)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            
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
            .alert(LocalizedStrings.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(LocalizedStrings.Shared.yesButton, role: .destructive) { homeViewModel.performDelete() }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) { homeViewModel.cancelDelete() }
            } message: {
                Text(LocalizedStrings.Alert.Habit.deleteMessage)
            }
            .alert(LocalizedStrings.Alert.Logout.title, isPresented: $showLogoutAlert) {
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

    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            content
                .tabItem {
                    Label("Habits", systemImage: "calendar")
                }
                .tag(HomeTab.habits)

            tabPlaceholder(systemImage: "wand.and.stars", title: "History")
                .tabItem {
                    Label("History", systemImage: "wand.and.stars")
                }
                .tag(HomeTab.history)

            tabPlaceholder(systemImage: "gearshape", title: "Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(HomeTab.settings)
        }
        .tint(themeManager.appPrimary)
    }

    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            scrollContent

            addHabitButton
        }
        .background(.appGray)
    }

    private var scrollContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                quoteCard

                if homeViewModel.uiState.listItems.isEmpty {
                    CustomEmptyView(
                        image: Image(.emptyView),
                        text: LocalizedStrings.HomePage.emptyView
                    )
                } else {
                    ForEach(homeViewModel.uiState.listItems) { item in
                        HabitListRowView(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                deleteSwipeButton(for: item.id)
                                editSwipeButton(for: item.id)
                            }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            .padding(.bottom, 96)
        }
        .background(.appGray)
    }

    @ViewBuilder
    private var quoteCard: some View {
        let cardContent = VStack(alignment: .leading, spacing: 16) {
            Text("\u{201C}")
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(themeManager.appSecondary)
                .frame(height: 24, alignment: .top)

            Text("\"\(homeViewModel.displayedQuote)\"")
                .font(.AppFont.rooneySansBold.size(16))
                .italic()
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.horizontal, 26)
        .padding(.vertical, 20)

        if #available(iOS 26.0, *) {
            cardContent
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
        } else {
            cardContent
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var addHabitButton: some View {
        Button {
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
        }
        .buttonStyle(.plain)
        .floatingAddButtonStyle(tint: themeManager.appPrimary)
        .padding(.trailing, 20)
        .padding(.bottom, 18)
    }

    private func tabPlaceholder(systemImage: String, title: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(20))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appGray)
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
        CustomButton(style: CustomButtonStylePreset.default()) {
            if homeViewModel.uiState.isEditingList {
                homeViewModel.stopEditingList()
            } else {
                isDropDownPresented = true
            }
        } label: {
            editingButtonLabel
        }
    }

    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.confirmDelete(id: id)
        } label: {
            Image(systemName: AppIconName.trash)
        }
        .tint(.red)
    }

    private func editSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.editHabit(id: id)
        } label: {
            Image(systemName: AppIconName.pencil)
        }
        .tint(.blue)
    }
}

private enum HomeTab {
    case habits
    case history
    case settings
}

private extension View {
    @ViewBuilder
    func floatingAddButtonStyle(tint: Color) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(tint).interactive(), in: .circle)
        } else {
            self.background(tint)
                .clipShape(Circle())
                .shadow(color: tint.opacity(0.35), radius: 12, y: 6)
        }
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
