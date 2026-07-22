//
//  HabitHistoryView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct HabitHistoryView: View {
    private var habitHistoryViewModel: HabitHistoryViewModel
    private let navigateToProfileSettings: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab = HabitJourneyTab.upcoming
    @State private var showDeleteAlert = false

    init(
        habitHistoryViewModel: HabitHistoryViewModel,
        navigateToProfileSettings: @escaping () -> Void
    ) {
        self.habitHistoryViewModel = habitHistoryViewModel
        self.navigateToProfileSettings = navigateToProfileSettings
    }

    var body: some View {
        content
            .background(.appGray)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                habitHistoryViewModel.fetchHabits()
            }
            .onChange(of: habitHistoryViewModel.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .alert(L10n.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(L10n.Shared.okButton, role: .destructive) {
                    habitHistoryViewModel.performDelete()
                }
                Button(L10n.Shared.cancelButton, role: .cancel) {
                    habitHistoryViewModel.cancelDelete()
                }
            } message: {
                Text(habitHistoryViewModel.deleteConfirmationMessage)
            }
    }

    private var content: some View {
        VStack(spacing: Spacing.none) {
            pageHeader
            tabPicker
            scrollContent
        }
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: L10n.HabitHistoryPage.headerTitle,
            systemImage: SystemIconName.leaf,
            onProfileTap: navigateToProfileSettings
        )
    }

    private var tabPicker: some View {
        HStack(spacing: Spacing.none) {
            tabButton(.upcoming)
            tabButton(.completed)
        }
        .padding(Spacing.x2Small)
        .liquidGlass(
            tint: themeManager.appSecondary,
            in: Capsule(),
            fallback: themeManager.appSecondary.opacity(Opacity.subtleBorder)
        )
        .padding(.horizontal, Spacing.x3Large)
        .padding(.bottom, Spacing.x6Large)
    }

    private func tabButton(_ tab: HabitJourneyTab) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            Text(tab.title)
                .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xSmall + LineWidth.thin)
                .background(isSelected ? themeManager.appPrimary : .clear)
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var scrollContent: some View {
        List {
            if selectedTab == .completed {
                completedContent
            } else {
                upcomingContent
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .scrollIndicators(.hidden)
    }

    private var achievementCountText: String {
        let count = habitHistoryViewModel.completedItems.count
        return L10n.HabitHistoryPage.achievementCount(count)
    }

    private var completedContent: some View {
        Group {
            
            completedSectionHeader

            if habitHistoryViewModel.completedItems.isEmpty {
                emptyCompletedCard
                    .historyListRowStyle()
            } else {
                ForEach(habitHistoryViewModel.completedItems) { item in
                    HabitJourneyCompletedCard(item: item)
                        .environmentObject(themeManager)
                        .historyListRowStyle()
                }
            }
        }
    }
    
    private var completedSectionHeader: some View {
        HabitHistorySectionHeader(
            title: L10n.HabitHistoryPage.masteryTitle,
            badgeText: achievementCountText
        )
        .environmentObject(themeManager)
        .historyListRowStyle()
    }


    private var upcomingContent: some View {
        Group {
            
            upcomingSectionHeader

            ForEach(habitHistoryViewModel.listItems) { item in
                HabitHistoryListRowView(item: item) {
                    habitHistoryViewModel.startHabit(id: item.id)
                }
                .environmentObject(themeManager)
                .historyListRowStyle()
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    deleteSwipeButton(for: item.id)
                }
            }

            ritualTip
                .historyListRowStyle()
        }
    }
    
    private var upcomingSectionHeader: some View {
        HabitHistorySectionHeader(
            title: L10n.HabitHistoryPage.plannedTitle,
            subtitle: L10n.HabitHistoryPage.plannedSubtitle
        )
        .historyListRowStyle()
    }

    private var emptyCompletedCard: some View {
        CustomEmptyView(
            image: Image(.emptyView),
            text: L10n.HabitHistoryPage.emptyCompleted,
            imageSize: Size.emptyImage
        )
    }

    private var ritualTip: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Label(L10n.HabitHistoryPage.ritualTipLabel, systemImage: SystemIconName.lightbulb)
                .font(.AppFont.rooneySansBold.size(FontSize.small))
                .foregroundStyle(themeManager.appPrimary)

            Text(L10n.HabitHistoryPage.ritualTipText)
                .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                .italic()
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
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
    }

    private func deleteSwipeButton(for id: UUID) -> some View {
        Button {
            habitHistoryViewModel.confirmDelete(id: id)
        } label: {
            Image(systemName: SystemIconName.trash)
        }
        .tint(.red)
    }
}

private enum HabitJourneyTab {
    case completed
    case upcoming

    var title: String {
        switch self {
        case .completed:
            return L10n.HabitHistoryPage.completedTab
        case .upcoming:
            return L10n.HabitHistoryPage.upcomingTab
        }
    }
}


private extension View {
    func historyListRowStyle() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                top: Spacing.none,
                leading: Spacing.x3Large,
                bottom: Spacing.xLarge,
                trailing: Spacing.x3Large
            ))
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let habitDependencies = dependencies.destinationDependencies.main.habits
    let fakeCoordinator = HabitHistoryCoordinator(dismiss: {
    })
    let viewModel = HabitHistoryViewModel(
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        reminderScheduler: habitDependencies.reminderScheduler
    )

    HabitHistoryView(
        habitHistoryViewModel: viewModel,
        navigateToProfileSettings: {}
    )
    .environmentObject(dependencies.themeManager)
}
