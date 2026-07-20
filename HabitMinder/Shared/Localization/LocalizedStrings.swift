//
//  LocalizedStrings.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

struct LocalizedStrings {
    private static func formatted(_ key: String, _ values: String...) -> String {
        var result = key.localized

        for value in values {
            if let range = result.range(of: "%@") ?? result.range(of: "%d") {
                result.replaceSubrange(range, with: value)
            }
        }

        return result
    }

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
        static var tabHabits: String { "homeTabHabits".localized }
        static var tabHistory: String { "homeTabHistory".localized }
        static var tabSettings: String { "homeTabSettings".localized }
        static var headerTitle: String { "homeHeaderTitle".localized }
        static var listTitle: String { "homeListTitle".localized }
        static var listSubtitle: String { "homeListSubtitle".localized }
        static var quoteLabel: String { "homeQuoteLabel".localized }
        static var doneButton: String { "doneButton".localized }
        static var defaultQuote: String { "defaultQuote".localized }
        static var emptyView: String { "emptyView".localized }
        static var watchEmptyView: String { "watchEmptyView".localized }

        static func quoted(_ quote: String) -> String {
            LocalizedStrings.formatted("homeQuoteFormat", quote)
        }
    }

    struct AddHabitPage {
        static var title: String { "addHabitTitle".localized }
        static var notificationAlertTitle: String { "habitNotificationAlertTitle".localized }
        static var notificationAlertMessage: String { "habitNotificationAlertMessage".localized }
        static var notificationSettingsButton: String { "habitNotificationSettingsButton".localized }
        static var identitySectionTitle: String { "habitIdentitySectionTitle".localized }
        static var titlePlaceholder: String { "habitTitlePlaceholder".localized }
        static var visualAnchorSectionTitle: String { "habitVisualAnchorSectionTitle".localized }
        static var selectIconHint: String { "habitSelectIconHint".localized }
        static var futureHabitToggle: String { "habitFutureToggle".localized }
        static var frequencySectionTitle: String { "habitFrequencySectionTitle".localized }
        static var commitmentSectionTitle: String { "habitCommitmentSectionTitle".localized }
        static var reminderSectionTitle: String { "habitReminderSectionTitle".localized }
        static var reminderSubtitle: String { "habitReminderSubtitle".localized }
        static var startJourneyButton: String { "habitStartJourneyButton".localized }

        static func commitmentDays(_ days: Int) -> String {
            LocalizedStrings.formatted("habitCommitmentDaysFormat", "\(days)")
        }
    }

    struct EditHabitPage {
        static var title: String { "editHabitTitle".localized }
        static var missHabitToast: String { "missHabitToast".localized }
        static var missHabitButton: String { "missHabitButton".localized }
    }

    struct FutureHabitsPage {
        static var title: String { "futureHabitsTitleLabel".localized }
        static var headerTitle: String { "futureHabitsHeaderTitle".localized }
        static var startNowButton: String { "futureHabitStartNowButton".localized }
        static var completedTab: String { "futureHabitCompletedTab".localized }
        static var upcomingTab: String { "futureHabitUpcomingTab".localized }
        static var masteryTitle: String { "futureHabitMasteryTitle".localized }
        static var plannedTitle: String { "futureHabitPlannedTitle".localized }
        static var plannedSubtitle: String { "futureHabitPlannedSubtitle".localized }
        static var completedStatus: String { "futureHabitCompletedStatus".localized }
        static var emptyCompleted: String { "futureHabitEmptyCompleted".localized }
        static var ritualTipLabel: String { "futureHabitRitualTipLabel".localized }
        static var ritualTipText: String { "futureHabitRitualTipText".localized }

        static func startInDays(_ days: Int) -> String {
            LocalizedStrings.formatted("futureHabitStartInDaysFormat", "\(days)")
        }

        static func achievementCount(_ count: Int) -> String {
            let key = count == 1 ? "futureHabitAchievementSingular" : "futureHabitAchievementPlural"
            return LocalizedStrings.formatted(key, "\(count)")
        }

        static func finishedDate(_ date: String) -> String {
            LocalizedStrings.formatted("futureHabitFinishedDateFormat", date)
        }

        static func streakDays(_ days: Int) -> String {
            LocalizedStrings.formatted("futureHabitStreakDaysFormat", "\(days)")
        }
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

        struct Weekday {
            static var sundayShort: String { "weekdaySundayShort".localized }
            static var mondayShort: String { "weekdayMondayShort".localized }
            static var tuesdayShort: String { "weekdayTuesdayShort".localized }
            static var wednesdayShort: String { "weekdayWednesdayShort".localized }
            static var thursdayShort: String { "weekdayThursdayShort".localized }
            static var fridayShort: String { "weekdayFridayShort".localized }
            static var saturdayShort: String { "weekdaySaturdayShort".localized }
        }
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

            static func journey(_ days: Int) -> String {
                LocalizedStrings.formatted("habitCellJourneyFormat", "\(days)")
            }

            static func progressDay(completed: Int, total: Int) -> String {
                LocalizedStrings.formatted("habitCellProgressFormat", "\(completed)", "\(total)")
            }

            static func streak(_ days: Int) -> String {
                LocalizedStrings.formatted("habitCellStreakFormat", "\(days)")
            }
        }
    }
}
