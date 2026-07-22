//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    private var homeViewModel: HomeViewModel
    private let navigateToProfileSettings: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    @AppStorage(UserDefaultKeys.dailyQuotes.rawValue) private var dailyQuotes = true
    @State private var showDeleteAlert = false

    init(
        homeViewModel: HomeViewModel,
        navigateToProfileSettings: @escaping () -> Void
    ) {
        self.homeViewModel = homeViewModel
        self.navigateToProfileSettings = navigateToProfileSettings
    }
   
    var body: some View {
        content
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
            .alert(L10n.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(L10n.Shared.yesButton, role: .destructive) { homeViewModel.performDelete() }
                Button(L10n.Shared.cancelButton, role: .cancel) { homeViewModel.cancelDelete() }
            } message: {
                Text(homeViewModel.deleteConfirmationMessage)
            }
    }

    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            scrollContent

            addHabitButton
        }
        .background(.appGray)
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: L10n.HomePage.headerTitle,
            systemImage: SystemIconName.leaf,
            onProfileTap: navigateToProfileSettings
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
            pageHeader
                .homeHeaderListRowStyle()

            if homeViewModel.listItems.isNotEmpty {
                listHeader
                    .homeHeaderListRowStyle()
            }

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

                if dailyQuotes {
                    quoteCard
                }
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
                .liquidGlass(
                    tint: themeManager.appPrimary,
                    in: Circle(),
                    fallback: themeManager.appPrimary
                )
        }
        .buttonStyle(.plain)
        .padding(.trailing, Spacing.x3Large)
        .padding(.bottom, Spacing.x2Large)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Image(systemName: SystemIconName.quoteBubble)
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

private extension View {
    func homeListRowStyle() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

    func homeHeaderListRowStyle() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let habitDependencies = dependencies.destinationDependencies.main.habits
    let fakeCoordinator = HomeCoordinator(navigate: { _ in
    })
    let viewModel = HomeViewModel(
        quote: "test",
        author: "test",
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        connectivityService: habitDependencies.connectivityService,
        userDefaultsStorage: habitDependencies.userDefaultsStorage,
        reminderScheduler: habitDependencies.reminderScheduler
    )
    HomeView(
        homeViewModel: viewModel,
        navigateToProfileSettings: {}
    )
    .environmentObject(dependencies.themeManager)
}
