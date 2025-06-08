//
//  HomeView.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
    
    init(viewModel: @autoclosure @escaping () -> HomeViewModel) {
        _homeViewModel = StateObject(wrappedValue: viewModel())
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
                Text("\(habit.daysLeft)" + LocalizedStrings.Cell.Habit.daysLeft)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
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
}

#Preview {
    let sessionManager = WatchSessionManager()
    let viewModel = HomeViewModel(sessionManager: sessionManager)
    HomeView(viewModel: viewModel)
}
