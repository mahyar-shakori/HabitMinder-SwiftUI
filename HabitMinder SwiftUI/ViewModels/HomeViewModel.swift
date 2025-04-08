//
//  HomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var isDropDownPresented = false
    @Published var navigationTarget: HomeNavigationTarget?
    @Published var isEditingList = false
    @Published var listItems: [HabitItem] = []
    
    @Published var showDeleteAlert: Bool = false
    @Published var itemToDelete: UUID? = nil
    
    @Published var itemToEdit: UUID? = nil

    @Published var showEditAlert: Bool = false
    
    @Published var showListEmptyAlert: Bool = false

    
    private let habitManager: DataManager<Habit>

    let quote: String
    
    func handleEditHabitList() {
        if listItems.isEmpty {
            showListEmptyAlert = true
        } else {
            showListEmptyAlert = false
            isEditingList.toggle()
        }
    }
    
    let dropDownItems = [
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.addNewHabit,
            image: Image(.addNewHabit),
            target: .addHabit
        ),
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.editHabitList,
            image: Image(.editHabitList),
            target: .editHabitList
        ),
        DropDownItem(
            title: LocalizedStrings.Cell.DropDown.rename,
            image: Image(.rename),
            target: .rename
        )
    ]
    
    init(quote: String, habitManager: DataManager<Habit>) {
            self.quote = quote
            self.habitManager = habitManager
            fetchHabits()
        }
   
    func fetchHabits() {
            let habits = habitManager.fetchAll()
            self.listItems = habits.map { habit in
                let (daysLeft, progress) = calculateProgress(for: habit)
                return HabitItem(id: habit.id, title: habit.title, daysLeft: daysLeft, progress: progress)
            }
        }
    
    private func calculateProgress(for habit: Habit) -> (daysLeft: Int, progress: Double) {
        let daysLeft = habit.createdAt.habitDaysCountSinceCreation(for: habit.id)
        let progress = Double(22 - daysLeft) / 22.0
        return (daysLeft, progress)
    }
    
    func handleDropDownSelection(index: Int) {
        guard dropDownItems.indices.contains(index) else { return }
        navigationTarget = dropDownItems[index].target
        isDropDownPresented = false
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        listItems.move(fromOffsets: source, toOffset: destination)
    }
    
    @MainActor
    func refresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        fetchHabits()
    }
    
    func confirmDelete(id: UUID) {
        itemToDelete = id
        showDeleteAlert = true
    }
    
    func confirmEdit(id: UUID) {
        itemToEdit = id
        showEditAlert = true
    }
   
    
    func performEdit() {
        guard let id = itemToEdit else { return }

        habitManager.update({ habit in
            habit.createdAt = Date() 
        }, forID: id)
        
        fetchHabits()
        itemToEdit = nil
        showEditAlert = false
    }

    
    
    func performDelete() {
        guard let id = itemToDelete else { return }
               habitManager.delete(byID: id)
               listItems.removeAll { $0.id == id }

               itemToDelete = nil
               showDeleteAlert = false
    }
}





extension Notification.Name {
    static let habitAdded = Notification.Name("habitAdded")
}







struct ProgressCircleView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.appSecondary, lineWidth: 7)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.accent, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 35, height: 35)
    }
}


enum HomeNavigationTarget {
    case addHabit
    case editHabitList
    case rename
}

struct DropDownItem: Identifiable {
    let id = UUID()
    let title: String
    let image: Image?
    let target: HomeNavigationTarget
}

struct HabitItem: Identifiable {
    let id: UUID
    let title: String
    let daysLeft: Int
    let progress: Double 
}


struct DropDownRowView: View {
    let item: DropDownItem
    
    var body: some View {
        HStack(spacing: 16) {
            image
            text
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    private var image: some View {
        item.image?
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .padding(.leading, 16)
    }
    
    private var text: some View {
        Text(item.title)
            .font(.AppFont.rooneySansRegular.size(17))
            .foregroundColor(.primary)
    }
}

struct DropDownSheetView: View {
    let items: [DropDownItem]
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    onSelect(index)
                } label: {
                    DropDownRowView(item: item)
                }
                if index != items.count - 1 {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
    }
}

struct CustomEmptyView: View {
    let image: Image
    let text: String
    
    var body: some View {
        VStack(spacing: 10) {
            image
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Text(text)
                .font(.AppFont.rooneySansRegular.size(17))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 48)
        }
        .padding()
    }
}


struct HabitListRowView: View {
    let item: HabitItem
    
    var body: some View {
        HStack(spacing: 16) {
            ProgressCircleView(progress: item.progress)
            
            Text(item.title)
                .font(.AppFont.rooneySansBold.size(18))
            
            Spacer()
            
            Text("\(item.daysLeft) days left")
                .font(.AppFont.rooneySansRegular.size(14))
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}


enum SystemIcon {
    static let trash = "trash"
    static let pencil = "pencil"
}
