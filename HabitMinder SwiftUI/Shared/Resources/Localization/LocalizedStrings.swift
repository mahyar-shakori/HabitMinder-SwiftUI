//
//  LocalizedStrings.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

struct LocalizedStrings {
    
    struct setLanguagePage {
        static var title: String { "SetLanguageTitle".localized }
    }
    
    struct IntroPage {
        static var firstTitle: String { "introFirstTitle".localized }
        static var firstDescription: String { "introFirstDescription".localized }
        static var secondTitle: String { "introSecondTitle".localized }
        static var secondDescription: String { "introSecondDescription".localized }
        static var skipButton: String { "skipButton".localized }
        static var nextButton: String { "nextButton".localized }
    }
    
    struct SetNamePage {
        static var hiDialog: String { "hiDialog".localized }
        static var userNamePlaceholder: String { "userNamePlaceholder".localized }
        static var continueButton: String { "continueButton".localized }
        static var error: String { "error".localized }
    }
    
    struct WelcomePage {
        static var welcome: String { "welcome".localized }
        static var guest: String { "guest".localized }
        static var defaultQuote: String { "defaultQuote".localized }
    }
    
    struct HomePage {
        static var title: String { "homeTitle".localized }
        static var doneButton: String { "doneButton".localized }
        static var emptyView: String { "emptyView".localized }
        static var watchEmptyView: String { "watchEmptyView".localized }
    }
    
    struct FutureHabitsPage {
        static var title: String { "futureHabitsTitleLabel".localized }
    }
    
    struct AddHabitPage {
        static var title: String { "addHabitTitle".localized }
    }
    
    struct Shared {
        static var habitPlaceholder: String { "habitPlaceholder".localized }
        static var saveButton: String { "saveButton".localized }
        static var cancelButton: String { "cancelButton".localized }
        static var okButton: String { "okButton".localized }
        static var yesButton: String { "yesButton".localized }
        static var noButton: String { "noButton".localized }
    }
    
    struct Alert {
        struct Network {
            static var title: String { "networkAlertTitle".localized }
            static var defaultError: String { "defaultError".localized }
        }
        
        struct Habit {
            static var deleteTitle: String { "deleteHabitAlertTitle".localized }
            static var deleteMessage: String { "deleteHabitAlertMessage".localized }
            static var editTitle: String { "editHabitAlertTitle".localized }
            static var editMessage: String { "editHabitAlertMessage".localized }
        }
    }

    struct Cell {
        struct DropDown {
            static var addNewHabit: String { "dropDownAddNewHabit".localized }
            static var futureHabitShowHide: String { "dropDownFutureHabitShow-Hide".localized }
            static var editHabitList: String { "dropDownEditHabitList".localized }
            static var rename: String { "dropDownRename".localized }
        }
        
        struct Habit {
            static var daysLeft: String { "HabitCellDaysLeft".localized }
        }
    }
}
