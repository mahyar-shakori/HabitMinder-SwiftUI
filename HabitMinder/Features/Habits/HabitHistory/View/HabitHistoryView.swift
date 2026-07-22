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
                .font(.AppFont.rooneySansBold.size(FontSize.medium))
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
                    completedCard(item)
                        .historyListRowStyle()
                }
            }
        }
    }
    
    private var completedSectionHeader: some View {
        HStack {
            Text(L10n.HabitHistoryPage.masteryTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Spacer()

            Text(achievementCountText)
                .font(.AppFont.rooneySansBold.size(FontSize.small))
                .foregroundStyle(themeManager.appPrimary)
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.xSmall - LineWidth.thin)
                .background(themeManager.appSecondary.opacity(Opacity.badgeBackground))
                .clipShape(Capsule())
        }
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
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.HabitHistoryPage.plannedTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(L10n.HabitHistoryPage.plannedSubtitle)
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, Spacing.x2Small)
        .historyListRowStyle()
    }

    private func completedCard(_ item: CompletedHabitItem) -> some View {
        VStack(spacing: Spacing.large) {
            completedCardHeader(item)
            completedProgressView
            completedStatusRow(item)
        }
        .padding(Spacing.xLarge)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.x2Large))
    }

    private func completedCardHeader(_ item: CompletedHabitItem) -> some View {
        HStack(alignment: .top, spacing: Spacing.large) {
            completedHabitIcon(item.iconName)
            completedHabitInfo(item)

            Spacer()

            completionMedalIcon
        }
    }

    private func completedHabitIcon(_ iconName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(themeManager.appSecondary.opacity(Opacity.completedIconBackground))

            Image(systemName: iconName)
                .font(.system(size: FontSize.x4Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x3Large, height: Size.x3Large)
    }

    private func completedHabitInfo(_ item: CompletedHabitItem) -> some View {
        VStack(alignment: .leading, spacing: Spacing.x2Small) {
            Text(item.title)
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .foregroundStyle(.primary)

            Text(L10n.HabitHistoryPage.finishedDate(item.completedAt.formatted(.dateTime.month(.abbreviated).day().year())))
                .font(.AppFont.rooneySansRegular.size(FontSize.large))
                .foregroundStyle(.secondary)
        }
    }

    private var completionMedalIcon: some View {
        Image(systemName: SystemIconName.medal)
            .font(.system(size: FontSize.x2Large, weight: .semibold))
            .foregroundStyle(themeManager.appPrimary)
            .padding(Spacing.xSmall)
            .background(.appGray)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
    }

    private var completedProgressView: some View {
        ProgressView(value: Scale.normal)
            .tint(themeManager.appPrimary)
            .scaleEffect(x: Scale.normal, y: Scale.progress, anchor: .center)
    }

    private func completedStatusRow(_ item: CompletedHabitItem) -> some View {
        HStack {
            Text(L10n.HabitHistoryPage.streakDays(item.commitmentDays))
            Spacer()
            Text(L10n.HabitHistoryPage.completedStatus)
        }
        .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
        .foregroundStyle(.secondary)
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
                .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
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
