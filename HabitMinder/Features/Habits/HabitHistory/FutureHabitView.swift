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
            .alert(LocalizedStrings.Alert.Habit.deleteTitle, isPresented: $showDeleteAlert) {
                Button(LocalizedStrings.Shared.okButton, role: .destructive) {
                    futureHabitViewModel.performDelete()
                }
                Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                    futureHabitViewModel.cancelDelete()
                }
            } message: {
                Text(futureHabitViewModel.deleteConfirmationMessage)
            }
    }

    private var content: some View {
        VStack(spacing: Metrics.zeroSpacing) {
            pageHeader
            tabPicker
            scrollContent
        }
    }

    private var pageHeader: some View {
        AppHeaderView(
            title: LocalizedStrings.FutureHabitsPage.headerTitle,
            systemImage: AppIconName.leaf
        )
    }

    private var tabPicker: some View {
        HStack(spacing: Metrics.zeroSpacing) {
            tabButton(.upcoming)
            tabButton(.completed)
        }
        .padding(Metrics.tabPickerPadding)
        .segmentedTabBackground(themeManager.appSecondary)
        .padding(.horizontal, Metrics.pageHorizontalPadding)
        .padding(.bottom, Metrics.tabPickerBottomPadding)
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
        return LocalizedStrings.FutureHabitsPage.achievementCount(count)
    }

    private var completedContent: some View {
        Group {
            HStack {
                Text(LocalizedStrings.FutureHabitsPage.masteryTitle)
                    .font(.AppFont.rooneySansBold.size(Metrics.sectionTitleFontSize))
                    .foregroundStyle(.primary)

                Spacer()

                Text(achievementCountText)
                    .font(.AppFont.rooneySansBold.size(Metrics.badgeFontSize))
                    .foregroundStyle(themeManager.appPrimary)
                    .padding(.horizontal, Metrics.achievementHorizontalPadding)
                    .padding(.vertical, Metrics.achievementVerticalPadding)
                    .background(themeManager.appSecondary.opacity(Metrics.achievementBackgroundOpacity))
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
            VStack(alignment: .leading, spacing: Metrics.sectionHeaderSpacing) {
                Text(LocalizedStrings.FutureHabitsPage.plannedTitle)
                    .font(.AppFont.rooneySansBold.size(Metrics.sectionTitleFontSize))
                    .foregroundStyle(.primary)

                Text(LocalizedStrings.FutureHabitsPage.plannedSubtitle)
                    .font(.AppFont.rooneySansRegular.size(Metrics.bodyFontSize))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, Metrics.sectionHeaderBottomPadding)
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
        VStack(spacing: Metrics.cardContentSpacing) {
            HStack(alignment: .top, spacing: Metrics.cardContentSpacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: Metrics.iconCornerRadius)
                        .fill(themeManager.appSecondary.opacity(Metrics.completedIconBackgroundOpacity))

                    Image(systemName: item.iconName)
                        .font(.system(size: Metrics.iconFontSize, weight: .medium))
                        .foregroundStyle(themeManager.appPrimary)
                }
                .frame(width: Metrics.iconContainerSize, height: Metrics.iconContainerSize)

                VStack(alignment: .leading, spacing: Metrics.completedTextSpacing) {
                    Text(item.title)
                        .font(.AppFont.rooneySansBold.size(Metrics.cardTitleFontSize))
                        .foregroundStyle(.primary)

                    Text(LocalizedStrings.FutureHabitsPage.finishedDate(item.completedAt.formatted(.dateTime.month(.abbreviated).day().year())))
                        .font(.AppFont.rooneySansRegular.size(Metrics.captionFontSize))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: AppIconName.medal)
                    .font(.system(size: Metrics.medalFontSize, weight: .semibold))
                    .foregroundStyle(themeManager.appPrimary)
                    .padding(Metrics.medalPadding)
                    .background(.appGray)
                    .clipShape(RoundedRectangle(cornerRadius: Metrics.medalCornerRadius))
            }

            ProgressView(value: Metrics.completedProgressValue)
                .tint(themeManager.appPrimary)
                .scaleEffect(x: Metrics.progressScaleX, y: Metrics.completedProgressScaleY, anchor: .center)

            HStack {
                Text(LocalizedStrings.FutureHabitsPage.streakDays(item.commitmentDays))
                Spacer()
                Text(LocalizedStrings.FutureHabitsPage.completedStatus)
            }
            .font(.AppFont.rooneySansBold.size(Metrics.statusFontSize))
            .foregroundStyle(.secondary)
        }
        .padding(Metrics.cardPadding)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.completedCardCornerRadius))
    }

    private var emptyCompletedCard: some View {
        CustomEmptyView(
            image: Image(.emptyView),
            text: LocalizedStrings.FutureHabitsPage.emptyCompleted,
            imageSize: Metrics.emptyImageSize
        )
    }

    private var ritualTip: some View {
        VStack(alignment: .leading, spacing: Metrics.tipSpacing) {
            Label(LocalizedStrings.FutureHabitsPage.ritualTipLabel, systemImage: AppIconName.lightbulb)
                .font(.AppFont.rooneySansBold.size(Metrics.badgeFontSize))
                .foregroundStyle(themeManager.appPrimary)

            Text(LocalizedStrings.FutureHabitsPage.ritualTipText)
                .font(.AppFont.rooneySansRegular.size(15))
                .italic()
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Metrics.tipPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.appSecondary.opacity(Metrics.tipBackgroundOpacity))
        .overlay {
            RoundedRectangle(cornerRadius: Metrics.tipCornerRadius)
                .strokeBorder(
                    themeManager.appPrimary.opacity(Metrics.tipBorderOpacity),
                    style: StrokeStyle(lineWidth: LineWidth.thin, dash: Metrics.tipBorderDash)
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: Metrics.tipCornerRadius))
    }

    private func deleteSwipeButton(for id: UUID) -> some View {
        Button(role: .destructive) {
            futureHabitViewModel.confirmDelete(id: id)
        } label: {
            Image(systemName: AppIconName.trash)
        }
    }
}

private enum HabitJourneyTab {
    case completed
    case upcoming

    var title: String {
        switch self {
        case .completed:
            return LocalizedStrings.FutureHabitsPage.completedTab
        case .upcoming:
            return LocalizedStrings.FutureHabitsPage.upcomingTab
        }
    }
}

private enum Metrics {
    static let zeroSpacing: CGFloat = 0
    static let tabPickerPadding: CGFloat = 4
    static let pageHorizontalPadding: CGFloat = 20
    static let tabPickerBottomPadding: CGFloat = 28
    static let sectionHeaderSpacing: CGFloat = 8
    static let sectionHeaderBottomPadding: CGFloat = 4
    static let sectionTitleFontSize: CGFloat = 24
    static let bodyFontSize: CGFloat = 15
    static let badgeFontSize: CGFloat = 12
    static let achievementHorizontalPadding: CGFloat = 14
    static let achievementVerticalPadding: CGFloat = 7
    static let achievementBackgroundOpacity: CGFloat = 0.6
    static let cardContentSpacing: CGFloat = 14
    static let cardPadding: CGFloat = 16
    static let cardTitleFontSize: CGFloat = 17
    static let completedTextSpacing: CGFloat = 4
    static let captionFontSize: CGFloat = 14
    static let statusFontSize: CGFloat = 11
    static let iconCornerRadius: CGFloat = 12
    static let iconFontSize: CGFloat = 18
    static let iconContainerSize: CGFloat = 48
    static let completedIconBackgroundOpacity: CGFloat = 0.55
    static let medalFontSize: CGFloat = 16
    static let medalPadding: CGFloat = 8
    static let medalCornerRadius: CGFloat = 8
    static let completedProgressValue: CGFloat = 1
    static let progressScaleX: CGFloat = 1
    static let completedProgressScaleY: CGFloat = 1.7
    static let completedCardCornerRadius: CGFloat = 18
    static let emptyImageSize: CGFloat = 150
    static let tipSpacing: CGFloat = 10
    static let tipPadding: CGFloat = 18
    static let tipCornerRadius: CGFloat = 16
    static let tipBackgroundOpacity: CGFloat = 0.18
    static let tipBorderOpacity: CGFloat = 0.18
    static let tipBorderDash: [CGFloat] = [3, 3]
    static let listRowTopInset: CGFloat = 0
    static let listRowBottomInset: CGFloat = 16
    static let segmentedBackgroundOpacity: CGFloat = 0.35
}

private extension View {
    func historyListRowStyle() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                top: Metrics.listRowTopInset,
                leading: Metrics.pageHorizontalPadding,
                bottom: Metrics.listRowBottomInset,
                trailing: Metrics.pageHorizontalPadding
            ))
    }

    @ViewBuilder
    func segmentedTabBackground(_ tint: Color) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular.tint(tint).interactive(), in: Capsule())
        } else {
            background(tint.opacity(Metrics.segmentedBackgroundOpacity))
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
