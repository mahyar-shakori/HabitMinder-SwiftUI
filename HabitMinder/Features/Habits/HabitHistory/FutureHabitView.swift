//
//  FutureHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct FutureHabitView: View {
    @StateObject private var futureHabitViewModel: FutureHabitViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab = HabitJourneyTab.upcoming
    @State private var showDeleteAlert = false

    init(futureHabitViewModel: FutureHabitViewModel) {
        _futureHabitViewModel = StateObject(wrappedValue: futureHabitViewModel)
    }

    var body: some View {
        content
            .background(.appGray)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                futureHabitViewModel.fetchHabits()
            }
            .onChange(of: futureHabitViewModel.uiState.itemToDelete) { _, id in
                showDeleteAlert = (id != nil)
            }
            .alert(L10n.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(L10n.Shared.okButton, role: .destructive) {
                    futureHabitViewModel.performDelete()
                }
                Button(L10n.Shared.cancelButton, role: .cancel) {
                    futureHabitViewModel.cancelDelete()
                }
            } message: {
                Text(futureHabitViewModel.deleteConfirmationMessage)
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
            title: L10n.FutureHabitsPage.headerTitle,
            systemImage: SystemIconName.leaf
        )
    }

    private var tabPicker: some View {
        HStack(spacing: Spacing.none) {
            tabButton(.upcoming)
            tabButton(.completed)
        }
        .padding(Spacing.x2Small)
        .segmentedTabBackground(themeManager.appSecondary)
        .padding(.horizontal, Spacing.x3Large)
        .padding(.bottom, Spacing.x6Large)
    }

    private func tabButton(_ tab: HabitJourneyTab) -> some View {
        SelectableChipButton(
            title: tab.title,
            isSelected: selectedTab == tab
        ) {
            selectedTab = tab
        }
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
        let count = futureHabitViewModel.uiState.completedItems.count
        return L10n.FutureHabitsPage.achievementCount(count)
    }

    private var completedContent: some View {
        Group {
            HStack {
                Text(L10n.FutureHabitsPage.masteryTitle)
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

            if futureHabitViewModel.uiState.completedItems.isEmpty {
                emptyCompletedCard
                    .historyListRowStyle()
            } else {
                ForEach(futureHabitViewModel.uiState.completedItems) { item in
                    completedCard(item)
                        .historyListRowStyle()
                }
            }
        }
    }

    private var upcomingContent: some View {
        Group {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text(L10n.FutureHabitsPage.plannedTitle)
                    .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                    .foregroundStyle(.primary)

                Text(L10n.FutureHabitsPage.plannedSubtitle)
                    .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, Spacing.x2Small)
            .historyListRowStyle()

            ForEach(futureHabitViewModel.uiState.listItems) { item in
                FutureHabitListRowView(item: item) {
                    futureHabitViewModel.startHabit(id: item.id)
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

    private func completedCard(_ item: CompletedHabitItem) -> some View {
        VStack(spacing: Spacing.large) {
            HStack(alignment: .top, spacing: Spacing.large) {
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(themeManager.appSecondary.opacity(Opacity.completedIconBackground))

                    Image(systemName: item.iconName)
                        .font(.system(size: FontSize.x4Large, weight: .medium))
                        .foregroundStyle(themeManager.appPrimary)
                }
                .frame(width: Size.x3Large, height: Size.x3Large)

                VStack(alignment: .leading, spacing: Spacing.x2Small) {
                    Text(item.title)
                        .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                        .foregroundStyle(.primary)

                    Text(L10n.FutureHabitsPage.finishedDate(item.completedAt.formatted(.dateTime.month(.abbreviated).day().year())))
                        .font(.AppFont.rooneySansRegular.size(FontSize.large))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: SystemIconName.medal)
                    .font(.system(size: FontSize.x2Large, weight: .semibold))
                    .foregroundStyle(themeManager.appPrimary)
                    .padding(Spacing.xSmall)
                    .background(.appGray)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
            }

            ProgressView(value: Scale.normal)
                .tint(themeManager.appPrimary)
                .scaleEffect(x: Scale.normal, y: Scale.progress, anchor: .center)

            HStack {
                Text(L10n.FutureHabitsPage.streakDays(item.commitmentDays))
                Spacer()
                Text(L10n.FutureHabitsPage.completedStatus)
            }
            .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
            .foregroundStyle(.secondary)
        }
        .padding(Spacing.xLarge)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.x2Large))
    }

    private var emptyCompletedCard: some View {
        CustomEmptyView(
            image: Image(.emptyView),
            text: L10n.FutureHabitsPage.emptyCompleted,
            imageSize: Size.emptyImage
        )
    }

    private var ritualTip: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Label(L10n.FutureHabitsPage.ritualTipLabel, systemImage: SystemIconName.lightbulb)
                .font(.AppFont.rooneySansBold.size(FontSize.small))
                .foregroundStyle(themeManager.appPrimary)

            Text(L10n.FutureHabitsPage.ritualTipText)
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
        Button(role: .destructive) {
            futureHabitViewModel.confirmDelete(id: id)
        } label: {
            Image(systemName: SystemIconName.trash)
        }
    }
}

private enum HabitJourneyTab {
    case completed
    case upcoming

    var title: String {
        switch self {
        case .completed:
            return L10n.FutureHabitsPage.completedTab
        case .upcoming:
            return L10n.FutureHabitsPage.upcomingTab
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

    @ViewBuilder
    func segmentedTabBackground(_ tint: Color) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular.tint(tint).interactive(), in: Capsule())
        } else {
            background(tint.opacity(Opacity.subtleBorder))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let habitDependencies = dependencies.destinationDependencies.main.habits
    let fakeCoordinator = HabitHistoryCoordinator(dismiss: {
    })
    let viewModel = FutureHabitViewModel(
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        reminderScheduler: habitDependencies.reminderScheduler
    )

    FutureHabitView(futureHabitViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
