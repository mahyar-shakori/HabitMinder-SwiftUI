//
//  LocalizedStrings.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

struct LocalizedStrings {
    
    struct IntroPage {
        static let firstTitle = NSLocalizedString("introFirstTitle", comment: "Title for the first introduction screen")
        static let firstDescription = NSLocalizedString("introFirstDescription", comment: "Description for the first introduction screen")
        static let secondTitle = NSLocalizedString("introSecondTitle", comment: "Title for the second introduction screen")
        static let secondDescription = NSLocalizedString("introSecondDescription", comment: "Description for the second introduction screen")
        static let skipButton = NSLocalizedString("skipButton", comment: "Button title for skip")
        static let nextButton = NSLocalizedString("nextButton", comment: "Button title for next")
    }
    
    struct SetNamePage {
        static let hiDialog = NSLocalizedString("hiDialog", comment: "Greeting dialog")
        static let userNamePlaceholder = NSLocalizedString("userNamePlaceholder", comment: "Placeholder for username text field")
        static let continueButton = NSLocalizedString("continueButton", comment: "Button title for continue")
        static let error = NSLocalizedString("error", comment: "Error message when name is not entered")
    }
    
    struct WelcomePage {
        static let welcome = NSLocalizedString("welcome", comment: "Welcome message")
        static let guest = NSLocalizedString("guest", comment: "Guest message")
        static let defaultQuote = NSLocalizedString("defaultQuote", comment: "Default quote used when the response exceeds 100 characters")
    }
    
    struct HomePage {
        static let title = NSLocalizedString("homeTitle", comment: "Title for home screen")
        static let doneButton = NSLocalizedString("doneButton", comment: "Button title for done")
        static let emptyView = NSLocalizedString("emptyView", comment: "Message for empty habit view")
        static let watchEmptyView = NSLocalizedString("watchEmptyView", comment: "Message for empty habit view in watch app")
    }
    
    struct AddHabitPage {
        static let title = NSLocalizedString("addHabitTitle", comment: "Title for add habit screen")
        static let habitPlaceholder = NSLocalizedString("habitPlaceholder", comment: "Placeholder for habit text field")
    }
    
    struct Shared {
        static let saveButton = NSLocalizedString("saveButton", comment: "Button title for save")
        static let cancelButton = NSLocalizedString("cancelButton", comment: "Button title for cancel")
        static let okButton = NSLocalizedString("okButton", comment: "Button title for ok")
        static let yesButton = NSLocalizedString("yesButton", comment: "Button title for yes")
        static let noButton = NSLocalizedString("noButton", comment: "Button title for no")
    }
    
    struct Alert {
        struct Network {
            static let title = NSLocalizedString("networkAlertTitle", comment: "Title for network error alert")
            static let defaultError = NSLocalizedString("defaultError", comment: "Default error message for Unknown network error")
        }
        
        struct Habit {
            static let listEmptyTitle = NSLocalizedString("habitListEmptyAlertTitle", comment: "Title for empty habit list alert")
            static let deleteTitle = NSLocalizedString("deleteHabitAlertTitle", comment: "Title for delete habit alert")
            static let deleteMessage = NSLocalizedString("deleteHabitAlertMessage", comment: "Message for delete habit alert")
            static let editTitle = NSLocalizedString("editHabitAlertTitle", comment: "Title for edit habit alert")
            static let editMessage = NSLocalizedString("editHabitAlertMessage", comment: "Message for edit habit alert")
        }
    }

    struct Cell {
        struct DropDown {
            static let addNewHabit = NSLocalizedString("dropDownAddNewHabit", comment: "Dropdown option to add a new habit")
            static let editHabitList = NSLocalizedString("dropDownEditHabitList", comment: "Dropdown option to edit habit list")
            static let rename = NSLocalizedString("dropDownRename", comment: "Dropdown option to rename user name")
        }
        
        struct Habit {
            static let daysLeft = NSLocalizedString("HabitCellDaysLeft", comment: "Remaining left days")
        }
    }
}
