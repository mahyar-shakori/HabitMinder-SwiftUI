//
//  HomeView.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            habitSection
                .navigationTitle(LocalizedStrings.HomePage.title)
                .onAppear {
                    WatchSessionManager.shared.configure(with: homeViewModel)
                }
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
    HomeView()
}
