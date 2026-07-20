//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var homeViewModel: HomeViewModel
    private let reminderScheduler: HabitReminderScheduling
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showDeleteAlert = false
    @State private var selectedTab = HomeTab.habits

    init(
        homeViewModel: HomeViewModel,
        reminderScheduler: HabitReminderScheduling
    ) {
        _homeViewModel = State(initialValue: homeViewModel)
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
            .alert(LocalizedStrings.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(LocalizedStrings.Shared.yesButton, role: .destructive) { homeViewModel.performDelete() }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) { homeViewModel.cancelDelete() }
            } message: {
                Text(homeViewModel.deleteConfirmationMessage)
            }
    }

    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            content
                .tabItem {
                    Label(LocalizedStrings.HomePage.tabHabits, systemImage: AppIconName.calendar)
                }
                .tag(HomeTab.habits)

            habitHistoryView
                .tabItem {
                    Label(LocalizedStrings.HomePage.tabHistory, systemImage: AppIconName.wandAndStars)
                }
                .tag(HomeTab.history)

            tabPlaceholder(systemImage: AppIconName.gearshape, title: LocalizedStrings.HomePage.tabSettings)
                .tabItem {
                    Label(LocalizedStrings.HomePage.tabSettings, systemImage: AppIconName.gearshape)
                }
                .tag(HomeTab.settings)
        }
        .tint(themeManager.appPrimary)
    }
    
    private var habitHistoryView: some View {
        let coordinator = HabitHistoryCoordinator {
            selectedTab = .habits
        }
        let viewModel = FutureHabitViewModel(
            dataManager: DataManager(context: modelContext),
            coordinator: coordinator,
            reminderScheduler: reminderScheduler
        )

        return FutureHabitView(futureHabitViewModel: viewModel)
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
            title: LocalizedStrings.HomePage.headerTitle,
            systemImage: AppIconName.leaf
        )
    }

    private var listHeader: some View {
        VStack(alignment: .leading, spacing: Metrics.listHeaderSpacing) {
            Text(LocalizedStrings.HomePage.listTitle)
                .font(.AppFont.rooneySansBold.size(Metrics.listTitleFontSize))
                .foregroundStyle(.primary)

            Text(LocalizedStrings.HomePage.listSubtitle)
                .font(.AppFont.rooneySansRegular.size(Metrics.bodyFontSize))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Metrics.listHeaderHorizontalPadding)
        .padding(.bottom, Metrics.listHeaderBottomPadding)
    }

    private var scrollContent: some View {
        List {
            if homeViewModel.listItems.isEmpty {
                CustomEmptyView(
                    image: Image(.emptyView),
                    text: LocalizedStrings.HomePage.emptyView
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
        FloatingActionButton {
            homeViewModel.goToAddHabitPage()
        }
        .padding(.trailing, Metrics.addButtonTrailingPadding)
        .padding(.bottom, Metrics.addButtonBottomPadding)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: Metrics.quoteSpacing) {
            Label(LocalizedStrings.HomePage.quoteLabel, systemImage: AppIconName.quoteBubble)
                .font(.AppFont.rooneySansBold.size(Metrics.quoteLabelFontSize))
                .foregroundStyle(themeManager.appPrimary)

            Text(LocalizedStrings.HomePage.quoted(homeViewModel.displayedQuote))
                .font(.AppFont.rooneySansRegular.size(Metrics.bodyFontSize))
                .italic()
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if homeViewModel.displayedAuthor.isNotEmpty {
                Text(homeViewModel.displayedAuthor)
                    .font(.AppFont.rooneySansRegular.size(Metrics.authorFontSize))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(Metrics.quotePadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.appSecondary.opacity(Metrics.quoteBackgroundOpacity))
        .overlay {
            RoundedRectangle(cornerRadius: Metrics.quoteCornerRadius)
                .strokeBorder(
                    themeManager.appPrimary.opacity(Metrics.quoteBorderOpacity),
                    style: StrokeStyle(lineWidth: LineWidth.thin, dash: Metrics.quoteBorderDash)
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: Metrics.quoteCornerRadius))
        .homeListRowStyle()
    }

    private func tabPlaceholder(systemImage: String, title: String) -> some View {
        VStack(spacing: Metrics.placeholderSpacing) {
            Image(systemName: systemImage)
                .font(.system(size: Metrics.placeholderIconSize, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)

            Text(title)
                .font(.AppFont.rooneySansBold.size(Metrics.placeholderTitleFontSize))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appGray)
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

private enum Metrics {
    static let listHeaderSpacing: CGFloat = 4
    static let listTitleFontSize: CGFloat = 24
    static let bodyFontSize: CGFloat = 15
    static let authorFontSize: CGFloat = 14
    static let listHeaderHorizontalPadding: CGFloat = 22
    static let listHeaderBottomPadding: CGFloat = 14
    static let addButtonTrailingPadding: CGFloat = 20
    static let addButtonBottomPadding: CGFloat = 18
    static let quoteSpacing: CGFloat = 10
    static let quoteLabelFontSize: CGFloat = 12
    static let quotePadding: CGFloat = 18
    static let quoteBackgroundOpacity: CGFloat = 0.18
    static let quoteBorderOpacity: CGFloat = 0.18
    static let quoteCornerRadius: CGFloat = 16
    static let quoteBorderDash: [CGFloat] = [3, 3]
    static let placeholderSpacing: CGFloat = 12
    static let placeholderIconSize: CGFloat = 36
    static let placeholderTitleFontSize: CGFloat = 20
}

private enum PreviewData {
    static let quote = LocalizedStrings.HomePage.defaultQuote
    static let author = LocalizedStrings.WelcomePage.welcome
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
        quote: PreviewData.quote,
        author: PreviewData.author,
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
