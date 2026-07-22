//
//  L10n.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 31/03/2025.
//

import Foundation

enum L10n {
    private static func localized(_ key: String) -> String {
        String(localized: String.LocalizationValue(key))
    }

    private static func formatted(_ key: String, _ values: String...) -> String {
        var result = localized(key)

        for value in values {
            if let range = result.range(of: "%@") ?? result.range(of: "%d") {
                result.replaceSubrange(range, with: value)
            }
        }

        return result
    }
    
    enum IntroPage {
        static let firstTitle = localized("introFirstTitle")
        static let firstDescription = localized("introFirstDescription")
        static let secondTitle = localized("introSecondTitle")
        static let secondDescription = localized("introSecondDescription")
        static let skipButton = localized("skipButton")
        static let nextButton = localized("nextButton")
    }

    enum SetNamePage {
        static let hiDialog = localized("hiDialog")
        static let userNamePlaceholder = localized("userNamePlaceholder")
        static let continueButton = localized("continueButton")
        static let error = localized("error")
    }

    enum WelcomePage {
        static let welcome = localized("welcome")
        static let guest = localized("guest")
    }

    enum HomePage {
        static let tabHabits = localized("homeTabHabits")
        static let tabHistory = localized("homeTabHistory")
        static let tabSettings = localized("homeTabSettings")
        static let headerTitle = localized("homeHeaderTitle")
        static let listTitle = localized("homeListTitle")
        static let listSubtitle = localized("homeListSubtitle")
        static let defaultQuote = localized("defaultQuote")
        static let defaultAuthor = localized("homeDefaultAuthor")
        static let emptyView = localized("emptyView")
        static let watchEmptyView = localized("watchEmptyView")

        static func quoted(_ quote: String) -> String {
            L10n.formatted("homeQuoteFormat", quote)
        }

        static func author(_ author: String) -> String {
            L10n.formatted("homeAuthorFormat", author)
        }
    }

    enum AddHabitPage {
        static let title = localized("addHabitTitle")
        static let introDescription = localized("addHabitIntroDescription")
        static let notificationAlertTitle = localized("habitNotificationAlertTitle")
        static let notificationAlertMessage = localized("habitNotificationAlertMessage")
        static let inAppNotificationAlertMessage = localized("habitInAppNotificationAlertMessage")
        static let notificationSettingsButton = localized("habitNotificationSettingsButton")
        static let identitySectionTitle = localized("habitIdentitySectionTitle")
        static let titlePlaceholder = localized("habitTitlePlaceholder")
        static let visualAnchorSectionTitle = localized("habitVisualAnchorSectionTitle")
        static let selectIconHint = localized("habitSelectIconHint")
        static let futureHabitToggle = localized("habitFutureToggle")
        static let frequencySectionTitle = localized("habitFrequencySectionTitle")
        static let commitmentSectionTitle = localized("habitCommitmentSectionTitle")
        static let reminderSectionTitle = localized("habitReminderSectionTitle")
        static let reminderSubtitle = localized("habitReminderSubtitle")
        static let startJourneyButton = localized("habitStartJourneyButton")
        static let frequencyDaily = localized("habitFrequencyDaily")
        static let frequencyWeekly = localized("habitFrequencyWeekly")
        static let frequencyCustom = localized("habitFrequencyCustom")

        static func commitmentDays(_ days: Int) -> String {
            L10n.formatted("habitCommitmentDaysFormat", "\(days)")
        }
    }

    enum EditHabitPage {
        static let title = localized("editHabitTitle")
        static let introDescription = localized("editHabitIntroDescription")
        static let missHabitToast = localized("missHabitToast")
        static let missHabitButton = localized("missHabitButton")
    }

    enum HabitHistoryPage {
        static let title = localized("habitHistoryTitle")
        static let headerTitle = localized("habitHistoryHeaderTitle")
        static let startNowButton = localized("habitHistoryStartNowButton")
        static let completedTab = localized("habitHistoryCompletedTab")
        static let upcomingTab = localized("habitHistoryFutureTab")
        static let masteryTitle = localized("habitHistoryMasteryTitle")
        static let plannedTitle = localized("habitHistoryPlannedTitle")
        static let plannedSubtitle = localized("habitHistoryPlannedSubtitle")
        static let completedStatus = localized("habitHistoryCompletedStatus")
        static let emptyCompleted = localized("habitHistoryEmptyCompleted")
        static let ritualTipLabel = localized("habitHistoryRitualTipLabel")
        static let ritualTipText = localized("habitHistoryRitualTipText")

        static func startInDays(_ days: Int) -> String {
            L10n.formatted("habitHistoryStartInDaysFormat", "\(days)")
        }

        static func achievementCount(_ count: Int) -> String {
            let key = count == 1 ? "habitHistoryAchievementSingular" : "habitHistoryAchievementPlural"
            return L10n.formatted(key, "\(count)")
        }

        static func finishedDate(_ date: String) -> String {
            L10n.formatted("habitHistoryFinishedDateFormat", date)
        }

        static func streakDays(_ days: Int) -> String {
            L10n.formatted("habitHistoryStreakDaysFormat", "\(days)")
        }
    }

    enum SettingPage {
        static let title = localized("settingTitle")
        static let userName = localized("userName")
        static let language = localized("Language")
        static let appColor = localized("appColor")
        static let setColor = localized("setColor")
        static let selectLanguage = localized("selectLanguage")
        static let chooseColor = localized("chooseColor")
        static let pickColor = localized("pickColor")
        static let defaultColor = localized("defaultColor")
        static let profile = localized("profile")
        static let editUserName = localized("editUserName")
        static let enterNewUserName = localized("enterNewUserName")
        static let profilePhoto = localized("profilePhoto")
        static let changePhoto = localized("changePhoto")
        static func memberSince(_ date: String) -> String {
            L10n.formatted("memberSinceFormat", date)
        }
        static let preferences = localized("preferences")
        static let support = localized("support")
        static let appSection = localized("settingsAppSection")
        static let notifications = localized("notifications")
        static let notificationsSubtitle = localized("notificationsSubtitle")
        static let appTheme = localized("appTheme")
        static let appThemeSubtitle = localized("appThemeSubtitle")
        static let appThemeIntroTitle = localized("appThemeIntroTitle")
        static let appThemeIntroDescription = localized("appThemeIntroDescription")
        static let appearanceSection = localized("appearanceSection")
        static let appearanceLight = localized("appearanceLight")
        static let appearanceDark = localized("appearanceDark")
        static let appearanceSystem = localized("appearanceSystem")
        static let accentColorSection = localized("accentColorSection")
        static let customColor = localized("customColor")
        static let customColorSubtitle = localized("customColorSubtitle")
        static let defaultColorSubtitle = localized("defaultColorSubtitle")
        static let helpSupport = localized("helpSupport")
        static let helpSupportSubtitle = localized("helpSupportSubtitle")
        static let rateUs = localized("rateUs")
        static let rateUsSubtitle = localized("rateUsSubtitle")
        static let logoutSubtitle = localized("logoutSubtitle")
        static let versionTagline = localized("versionTagline")

        static func appVersion(_ version: String) -> String {
            L10n.formatted("appVersionFormat", version)
        }
    }

    enum NotificationSettings {
        static let introTitle = localized("notificationSettingsIntroTitle")
        static let introDescription = localized("notificationSettingsIntroDescription")
        static let general = localized("notificationSettingsGeneral")
        static let allowNotifications = localized("notificationSettingsAllowNotifications")
        static let allowNotificationsDescription = localized("notificationSettingsAllowDescription")
        static let ritualReminders = localized("notificationSettingsRitualReminders")
        static let dailyReminders = localized("notificationSettingsDailyReminders")
        static let reminderTime = localized("notificationSettingsReminderTime")
        static let motivation = localized("notificationSettingsMotivation")
        static let dailyQuotes = localized("notificationSettingsDailyQuotes")
        static let dailyQuotesDescription = localized("notificationSettingsDailyQuotesDescription")
        static let journeyCompletion = localized("notificationSettingsJourneyCompletion")
        static let journeyCompletionDescription = localized("notificationSettingsJourneyCompletionDescription")
    }

    enum Notification {
        static let habitReminderTitle = localized("habitReminderNotificationTitle")
        static let journeyCompletionTitle = localized("journeyCompletionNotificationTitle")

        static func habitReminderBody(_ title: String) -> String {
            L10n.formatted("habitReminderNotificationBodyFormat", title)
        }

        static func journeyCompletionBody(_ title: String) -> String {
            L10n.formatted("journeyCompletionNotificationBodyFormat", title)
        }
    }

    enum Shared {
        static let habitPlaceholder = localized("habitPlaceholder")
        static let saveButton = localized("saveButton")
        static let cancelButton = localized("cancelButton")
        static let okButton = localized("okButton")
        static let yesButton = localized("yesButton")
        static let noButton = localized("noButton")
        static let backButton = localized("backButton")

        enum Weekday {
            static let sundayShort = localized("weekdaySundayShort")
            static let mondayShort = localized("weekdayMondayShort")
            static let tuesdayShort = localized("weekdayTuesdayShort")
            static let wednesdayShort = localized("weekdayWednesdayShort")
            static let thursdayShort = localized("weekdayThursdayShort")
            static let fridayShort = localized("weekdayFridayShort")
            static let saturdayShort = localized("weekdaySaturdayShort")
        }
    }

    enum Alert {
        enum Network {
            static let title = localized("networkAlertTitle")
            static let unknownError = localized("networkAlertUnknownError")
            static let invalidURL = localized("networkAlertInvalidURL")
            static let decodingFailed = localized("networkAlertDecodingFailed")
            static let badResponse = localized("networkAlertBadResponse")
            static let invalidMultipartBody = localized("networkAlertInvalidMultipartBody")
        }

        enum Habit {
            static let deleteTitle = localized("deleteHabitAlertTitle")
            static let deleteMessage = localized("deleteHabitAlertMessage")
            static let editTitle = localized("editHabitAlertTitle")
            static let editMessage = localized("editHabitAlertMessage")

            static func deleteMessage(title: String) -> String {
                L10n.formatted("deleteHabitNamedAlertMessage", title)
            }
        }

        enum Logout {
            static let title = localized("logoutAlertTitle")
            static let message = localized("logoutAlertMessage")
        }
    }

    enum Cell {
        enum DropDown {
            static let addNewHabit = localized("dropDownAddNewHabit")
            static let futureHabit = localized("dropDownFutureHabit")
            static let editHabitList = localized("dropDownEditHabitList")
            static let setting = localized("dropDownSetting")
            static let logout = localized("dropDownLogout")
        }

        enum Habit {
            static let daysLeft = localized("HabitCellDaysLeft")

            static func journey(_ days: Int) -> String {
                L10n.formatted("habitCellJourneyFormat", "\(days)")
            }

            static func progressDay(completed: Int, total: Int) -> String {
                L10n.formatted("habitCellProgressFormat", "\(completed)", "\(total)")
            }

            static func streak(_ days: Int) -> String {
                L10n.formatted("habitCellStreakFormat", "\(days)")
            }
        }
    }
}
