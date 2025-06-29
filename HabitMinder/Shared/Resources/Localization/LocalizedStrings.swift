//
//  LocalizedStrings.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

struct LocalizedStrings {
    struct SetLanguagePage {
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
    }

    struct HomePage {
        static var title: String { "homeTitle".localized }
        static var doneButton: String { "doneButton".localized }
        static var defaultQuote: String { "defaultQuote".localized }
        static var emptyView: String { "emptyView".localized }
        static var watchEmptyView: String { "watchEmptyView".localized }
    }

    struct AddHabitPage {
        static var title: String { "addHabitTitle".localized }
    }

    struct EditHabitPage {
        static var title: String { "editHabitTitle".localized }
        static var missHabitToast: String { "missHabitToast".localized }
        static var missHabitButton: String { "missHabitButton".localized }
    }

    struct FutureHabitsPage {
        static var title: String { "futureHabitsTitleLabel".localized }
    }

    struct SettingPage {
        static var title: String { "settingTitle".localized }
        static var userName: String { "userName".localized }
        static var language: String { "Language".localized }
        static var appColor: String { "appColor".localized }
        static var setColor: String { "setColor".localized }
        static var selectLanguage: String { "selectLanguage".localized }
        static var chooseColor: String { "chooseColor".localized }
        static var pickColor: String { "pickColor".localized }
        static var defaultColor: String { "defaultColor".localized }
        static var editUserName: String { "editUserName".localized }
        static var enterNewUserName: String { "enterNewUserName".localized }
    }

    struct Shared {
        static var habitPlaceholder: String { "habitPlaceholder".localized }
        static var saveButton: String { "saveButton".localized }
        static var cancelButton: String { "cancelButton".localized }
        static var okButton: String { "okButton".localized }
        static var yesButton: String { "yesButton".localized }
        static var noButton: String { "noButton".localized }
        static var backButton: String { "backButton".localized }
    }

    struct Alert {
        struct Network {
            static var title: String { "networkAlertTitle".localized }
            static var unknownError: String { "networkAlertUnknownError".localized }
            static var invalidURL: String { "networkAlertInvalidURL".localized }
            static var decodingFailed: String { "networkAlertDecodingFailed".localized }
            static var badResponse: String { "networkAlertBadResponse".localized }
            static var invalidMultipartBody: String { "networkAlertInvalidMultipartBody".localized }
        }

        struct Habit {
            static var deleteTitle: String { "deleteHabitAlertTitle".localized }
            static var deleteMessage: String { "deleteHabitAlertMessage".localized }
            static var editTitle: String { "editHabitAlertTitle".localized }
            static var editMessage: String { "editHabitAlertMessage".localized }
        }

        struct Logout {
            static var title: String { "logoutAlertTitle".localized }
            static var message: String { "logoutAlertMessage".localized }
        }
    }

    struct Cell {
        struct DropDown {
            static var addNewHabit: String { "dropDownAddNewHabit".localized }
            static var futureHabit: String { "dropDownFutureHabit".localized }
            static var editHabitList: String { "dropDownEditHabitList".localized }
            static var setting: String { "dropDownSetting".localized }
            static var logout: String { "dropDownLogout".localized }
        }

        struct Habit {
            static var daysLeft: String { "HabitCellDaysLeft".localized }
        }
    }
}
