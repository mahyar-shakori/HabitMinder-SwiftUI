//
//  LocalizedStrings.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/15/25.
//

import Foundation

struct LocalizedStrings {
    
    struct IntroPage {
        static let firstTitleLabel = NSLocalizedString("introFirstTitleLabel", comment: "Title for the first introduction screen")
        static let firstDescriptionLabel = NSLocalizedString("introFirstDescriptionLabel", comment: "Description for the first introduction screen")
        static let secondTitleLabel = NSLocalizedString("introSecondTitleLabel", comment: "Title for the second introduction screen")
        static let secondDescriptionLabel = NSLocalizedString("introSecondDescriptionLabel", comment: "Description for the second introduction screen")
        static let skipButton = NSLocalizedString("skipButton", comment: "Skip button text")
        static let nextButton = NSLocalizedString("nextButton", comment: "Next button text")
    }
    
    struct SetNamePage {
        static let hiDialogLabel = NSLocalizedString("hiDialogLabel", comment: "Greeting dialog")
        static let userNamePlaceholder = NSLocalizedString("userNameTextFieldPplaceholder", comment: "Placeholder for username text field")
        static let continueButton = NSLocalizedString("continueButton", comment: "Continue button text")
        static let errorLabel = NSLocalizedString("errorLabel", comment: "Error message when name is not entered")
    }
    
    struct WelcomePage {
        static let welcomeLabel = NSLocalizedString("welcomeLabel", comment: "Welcome message")
        static let guestLabel = NSLocalizedString("guestLabel", comment: "Guest message")
        static let defaultQuote = NSLocalizedString("defaultQuote", comment: "Default quote used when the response exceeds 100 characters")
    }
    
    struct HomePage {
        static let myHabitsTitleLabel = NSLocalizedString("myHabitsTitleLabel", comment: "Title for my habits section")
        static let futureHabitsTitleLabel = NSLocalizedString("futureHabitsTitleLabel", comment: "Title for future habits section")
        static let doneButton = NSLocalizedString("doneButton", comment: "Done button text")
        static let emptyViewLabel = NSLocalizedString("emptyViewLabel", comment: "Message for empty habit view")
    }
    
    struct AddHabitPage {
        static let titleLabel = NSLocalizedString("addHabitTitleLabel", comment: "Title for adding a habit")
        static let reminderLabel = NSLocalizedString("reminderLabel", comment: "Label for reminder")
        static let dateLabel = NSLocalizedString("dateLabel", comment: "Label for date picker")
        static let addReminderButton = NSLocalizedString("addReminderButton", comment: "Button text to add a reminder")
    }
    
    struct EditHabitPage {
        static let titleLabel = NSLocalizedString("editHabitTitleLabel", comment: "Title for editing a habit")
        static let missHabitToastLabel = NSLocalizedString("missHabitToastLabel", comment: "Toast message for missed habit")
        static let missHabitButton = NSLocalizedString("missHabitButton", comment: "Button text for missed habit")
    }
    
    struct Shared {
        static let saveButton = NSLocalizedString("saveButton", comment: "Save button text")
        static let cancelButton = NSLocalizedString("cancelButton", comment: "Cancel button text")
        static let okButton = NSLocalizedString("okButton", comment: "OK button text")
        static let yesButton = NSLocalizedString("yesButton", comment: "Yes button text")
        static let noButton = NSLocalizedString("noButton", comment: "No button text")
        static let habitPlaceholder = NSLocalizedString("habitTextFieldPlaceholder", comment: "Placeholder for habit text field")
    }
    
    struct Alert {
        static let QustionMark = NSLocalizedString("qustionMark", comment: "Qustion mark")

        struct Network {
            static let title = NSLocalizedString("networkAlertTitle", comment: "Title for network error alert")
        }
        
        struct Habit {
            static let listEmptyTitle = NSLocalizedString("habitListEmptyAlertTitle", comment: "Title for empty habit list alert")
            static let deleteTitle = NSLocalizedString("deleteHabitAlertTitle", comment: "Title for delete habit alert")
            static let deleteMessage = NSLocalizedString("deleteHabitAlertMessage", comment: "Message for delete habit alert")
        }
        
        struct Reminder {
            static let deleteTitle = NSLocalizedString("deleteReminderAlertTitle", comment: "Title for delete reminder alert")
            static let deleteMessage = NSLocalizedString("deleteReminderAlertMessage", comment: "Message for delete reminder alert")
        }
        
        struct Date {
            static let textFieldEmptyTitle = NSLocalizedString("dateTextFieldEmptyTitle", comment: "Message for empty date text field")
        }
        
        struct Notification {
            static let title = NSLocalizedString("notificationAlertTitle", comment: "Title for notification settings alert")
            static let message = NSLocalizedString("notificationAlertMessage", comment: "Message for notification settings alert")
            static let settingButton = NSLocalizedString("notificationAlertButton", comment: "Button text for opening settings")
        }
    }

    struct Notification {
        static let message = NSLocalizedString("notificationMessage", comment: "Message for notification")
    }
    
    struct Cell {
        struct DropDown {
            static let addNewHabitOption = NSLocalizedString("dropDownAddNewHabit", comment: "Dropdown option to add a new habit")
            static let futureHabitShowHideOption = NSLocalizedString("dropDownFutureHabitShow-Hide", comment: "Dropdown option to show or hide future habits")
            static let editHabitListOption = NSLocalizedString("dropDownEditHabitList", comment: "Dropdown option to edit habit list")
            static let quoteOffOption = NSLocalizedString("dropDownQuoteOff", comment: "Dropdown option to turn off quote")
            static let renameOption = NSLocalizedString("dropDownRename", comment: "Dropdown option to rename user name")
        }
        
        struct Habit {
            static let daysLeft = NSLocalizedString("HabitCellDaysLeftLabel", comment: "Label for remaining days")
        }
    }
}
