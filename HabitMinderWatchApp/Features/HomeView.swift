//
//  HomeView.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        NavigationStack {
            habitSection
                .navigationTitle(LocalizedStrings.HomePage.title)
        }
    }
    
    private var habitList: some View {
        List(homeViewModel.habits, id: \.self) { habit in
            HStack {
                Text(habit.title)
                Spacer()
                Text(daysLeftText(for: habit))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, Metrics.rowVerticalPadding)
        }
    }
    
    @ViewBuilder
    private var habitSection: some View {
        if homeViewModel.habits.isEmpty {
            emptyStateView
        } else {
            habitList
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text(LocalizedStrings.HomePage.watchEmptyView)
            Spacer()
        }
    }

    private func daysLeftText(for habit: HabitData) -> String {
        habit.daysLeft.description + LocalizedStrings.Cell.Habit.daysLeft
    }
}

private enum Metrics {
    static let rowVerticalPadding: CGFloat = 8
}

#Preview {
    let sessionManager = WatchSessionManager()
    let viewModel = HomeViewModel(sessionManager: sessionManager)
    HomeView(homeViewModel: viewModel)
}
