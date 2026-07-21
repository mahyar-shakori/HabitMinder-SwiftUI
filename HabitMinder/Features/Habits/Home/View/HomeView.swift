//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    private var homeViewModel: HomeViewModel
    private let reminderScheduler: HabitReminderScheduling
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showDeleteAlert = false
    @State private var selectedTab = HomeTab.habits

    init(
        homeViewModel: HomeViewModel,
        reminderScheduler: HabitReminderScheduling
    ) {
        self.homeViewModel = homeViewModel
        self.reminderScheduler = reminderScheduler
    }
   
    var body: some View {
        tabContent
            .navigationBarBackButtonHidden(true)
            .onChange(of: homeViewModel.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .onReceive(
                NotificationCenter.default.publisher(for: AppNotification.Habit.added)
                    .merge(with: NotificationCenter.default.publisher(for: AppNotification.Habit.edited))
                    .merge(with: NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
            ) { _ in
                homeViewModel.fetchHabits()
            }
            .onReceive(NotificationCenter.default.publisher(for: AppNotification.Habit.futureAdded)) { _ in
                selectedTab = .history
            }
            .onReceive(NotificationCenter.default.publisher(for: AppNotification.Habit.futureStarted)) { _ in
                homeViewModel.fetchHabits()
                selectedTab = .habits
            }
            .alert(L10n.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(L10n.Shared.yesButton, role: .destructive) { homeViewModel.performDelete() }
                Button(L10n.Shared.cancelButton, role: .cancel) { homeViewModel.cancelDelete() }
            } message: {
                Text(homeViewModel.deleteConfirmationMessage)
            }
    }

    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            content
                .tabItem {
                    Label(L10n.HomePage.tabHabits, systemImage: SystemIconName.calendar)
                }
                .tag(HomeTab.habits)

            habitHistoryView
                .tabItem {
                    Label(L10n.HomePage.tabHistory, systemImage: SystemIconName.wandAndStars)
                }
                .tag(HomeTab.history)

            tabPlaceholder(systemImage: SystemIconName.gearshape, title: L10n.HomePage.tabSettings)
                .tabItem {
                    Label(L10n.HomePage.tabSettings, systemImage: SystemIconName.gearshape)
                }
                .tag(HomeTab.settings)
        }
        .tint(themeManager.appPrimary)
    }
    
    private var habitHistoryView: some View {
        let coordinator = HabitHistoryCoordinator {
            selectedTab = .habits
        }
        let viewModel = HabitHistoryViewModel(
            dataManager: DataManager(context: modelContext),
            coordinator: coordinator,
            reminderScheduler: reminderScheduler
        )

        return HabitHistoryView(habitHistoryViewModel: viewModel)
            .environmentObject(themeManager)
    }

    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                pageHeader

                if homeViewModel.listItems.isNotEmpty {
                    listHeader
                }

                scrollContent
            }

            addHabitButton
        }
        .background(.appGray)
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: L10n.HomePage.headerTitle,
            systemImage: SystemIconName.leaf
        )
    }

    private var listHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.x2Small) {
            Text(L10n.HomePage.listTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(L10n.HomePage.listSubtitle)
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.x4Large)
        .padding(.bottom, Spacing.large)
    }

    private var scrollContent: some View {
        List {
            if homeViewModel.listItems.isEmpty {
                CustomEmptyView(
                    image: Image(.emptyView),
                    text: L10n.HomePage.emptyView
                )
                .homeListRowStyle()
            } else {
                ForEach(homeViewModel.listItems) { item in
                    HabitListRowView(item: item)
                        .homeListRowStyle()
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            deleteSwipeButton(for: item.id)
                            editSwipeButton(for: item.id)
                        }
                }
                .onMove(perform: homeViewModel.moveItem)

                quoteCard
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .environment(\.editMode, .constant(homeViewModel.isEditingList ? .active : .inactive))
    }
    
    private var addHabitButton: some View {
        Button {
            homeViewModel.goToAddHabitPage()
        } label: {
            Image(systemName: SystemIconName.plus)
                .font(.system(size: Size.buttonIcon, weight: .medium))
                .foregroundStyle(.appWhite)
                .frame(width: Size.x4Large, height: Size.x4Large)
                .circleBackground(themeManager.appPrimary)
        }
        .buttonStyle(.plain)
        .padding(.trailing, Spacing.x3Large)
        .padding(.bottom, Spacing.x2Large)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Label(L10n.HomePage.quoteLabel, systemImage: SystemIconName.quoteBubble)
                .font(.AppFont.rooneySansBold.size(FontSize.small))
                .foregroundStyle(themeManager.appPrimary)

            Text(L10n.HomePage.quoted(homeViewModel.displayedQuote))
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                .italic()
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if homeViewModel.displayedAuthor.isNotEmpty {
                Text(homeViewModel.displayedAuthor)
                    .font(.AppFont.rooneySansRegular.size(FontSize.large))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(Spacing.x2Large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.appSecondary.opacity(Opacity.subtle))
        .overlay {
            RoundedRectangle(cornerRadius: CornerRadius.xLarge)
                .strokeBorder(
                    themeManager.appPrimary.opacity(Opacity.subtle),
                    style: StrokeStyle(lineWidth: LineWidth.thin, dash: StrokeDash.subtle)
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xLarge))
        .homeListRowStyle()
    }

    private func tabPlaceholder(systemImage: String, title: String) -> some View {
        VStack(spacing: Spacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: Size.xLarge, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(FontSize.x5Large))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appGray)
    }

    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.confirmDelete(id: id)
        } label: {
            Image(systemName: SystemIconName.trash)
        }
        .tint(.red)
    }

    private func editSwipeButton(for id: UUID) -> some View {
        Button {
            homeViewModel.editHabit(id: id)
        } label: {
            Image(systemName: SystemIconName.pencil)
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
    func homeListRowStyle() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let habitDependencies = dependencies.destinationDependencies.main.habits
    let fakeCoordinator = HomeCoordinator(navigate: { _ in
    })
    let reminderScheduler = habitDependencies.reminderScheduler
    let viewModel = HomeViewModel(
        quote: "test",
        author: "test",
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        connectivityService: habitDependencies.connectivityService,
        userDefaultsStorage: habitDependencies.userDefaultsStorage,
        reminderScheduler: reminderScheduler
    )
    HomeView(
        homeViewModel: viewModel,
        reminderScheduler: reminderScheduler
    )
    .environmentObject(dependencies.themeManager)
}
